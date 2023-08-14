import SwiftUI
import UIKit

protocol ConversationListContainerIxResponder {
    func onDelete(uuid: UUID, isCurrentUser: Bool) -> Void
}

struct ConversationListContainer: UIViewControllerRepresentable {
    @Binding var messages: [Message]

    func makeUIViewController(context _: Context) -> ConversationTableViewController {
        ConversationTableViewController(style: .plain)
    }

    func updateUIViewController(_ tableViewController: ConversationTableViewController, context _: Context) {
        tableViewController.update(messages: messages) {
            resignFirstResponder()
        }
    }
}


public class ConversationTableViewController: UITableViewController {
    private var messages: [Message] = []
    private var onTap: (() -> Void)?
    override init(style: UITableView.Style) {
        super.init(style: style)
        tableView.register(
            ConversationHostingCell<ConversationMessageContainerConnector>.self,
            forCellReuseIdentifier: "ConversationHostingCell<ConversationMessageContainerConnector>"
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear

        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewDidTap))
        tableView.addGestureRecognizer(tap)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        /// Костыль для ограничения постоянного скролла к низу списка сообщений
        /// 1. Скролл должен отрабатывать единожды при открытии экрана
        /// 2. Каждый раз, когда коллекция сообщений изменилась
        /// Задержка здесь необходима, т.к., коллекция успевает несколько раз обновиться, прежде, чем будет загружена таблица
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollToBottom()
        }
        self.updateTableContentInset()
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "contentSize",
              let newValue = change?[.newKey],
              let newSize = newValue as? CGSize
        else { return }
        
        print("Table view new size \(newSize)")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(messages: [Message], onTap: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.messages = messages
            self.updateTableContentInset()
        }

        self.onTap = onTap

        if messages != self.messages {
            self.scrollToBottom()
        }
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        messages.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        var currentCell = UITableViewCell()

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ConversationHostingCell<ConversationMessageContainerConnector>",
            for: indexPath
        ) as? ConversationHostingCell<ConversationMessageContainerConnector>
        else { preconditionFailure() }
        cell.tag = message.id.hashToInt()
        cell.set(rootView: ConversationMessageContainerConnector(messageID: message.id, ixResponder: self), parent: self)
        currentCell = cell
        currentCell.backgroundColor = .clear

        return currentCell
    }

    private func scrollToBottom() {
        guard messages.count > 5 else { return }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @objc
    private func tableViewDidTap() {
        onTap?()
    }
    
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
        self.tableView.reloadData()
    }
}

extension ConversationTableViewController: ConversationListContainerIxResponder {
    func onDelete(uuid: UUID, isCurrentUser: Bool) {
        DispatchQueue.main.async {
            if let idx = self.messages.firstMessageIndex(uuid) {
                self.messages.remove(at: idx)
                for cell in self.tableView.visibleCells {
                    if cell.tag == uuid.hashToInt() {
                        if let indexPath = self.tableView.indexPath(for: cell) {
                            let animation: UITableView.RowAnimation = isCurrentUser ? .right : .left
                            self.tableView.deleteRows(at: [indexPath], with: animation)
                            self.updateTableContentInset()
                        }
                        break
                    }
                }
            }
        }
    }
    
}

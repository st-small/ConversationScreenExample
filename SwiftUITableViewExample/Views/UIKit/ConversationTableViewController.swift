import SwiftUI
import UIKit

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


public final class ConversationTableViewController: UITableViewController {
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
            self.tableView.reloadData()
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

        cell.set(rootView: ConversationMessageContainerConnector(messageID: message.id, onDelete: { id, isCurrentUser in
            DispatchQueue.main.async {
                if let idx = self.messages.firstMessageIndex(id) {
                    self.messages.remove(at: idx)

                    if let indexPath = tableView.indexPath(for: cell) {
                        let animation: UITableView.RowAnimation = isCurrentUser ? .right : .left
                        tableView.deleteRows(at: [indexPath], with: animation)
                    }
                }
            }
        }), parent: self)
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
}


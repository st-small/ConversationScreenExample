import SwiftUI
import UIKit

public final class ConversationHostingCell<Content: View>: UITableViewCell {
    private let hostingController = UIHostingController<Content?>(rootView: nil)

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(rootView: Content, parent: UIViewController) {
        hostingController.rootView = rootView
        hostingController.view.invalidateIntrinsicContentSize()

        let requiresControllerMove = hostingController.parent != parent
        if requiresControllerMove {
            parent.addChild(hostingController)
        }

        if !contentView.subviews.contains(hostingController.view) {
            contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parent)
        }
    }
}


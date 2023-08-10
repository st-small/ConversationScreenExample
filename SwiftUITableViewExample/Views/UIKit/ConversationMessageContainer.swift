import SwiftUI

struct ConversationMessageContainerConnector: Connector {
    let messageID: UUID
    let onDelete: (UUID, Bool) -> Void

    func map(store: AppStore) -> some View {
        let message = store.state.conversation.messages
            .first(where: { $0.id == messageID })
        let isSentByCurrentUser = message?.status == .outgoing

        return ConversationMessageContainer(
            message: ChatMessage(
                id: messageID,
                text: message?.content ?? "",
                image: message?.image,
                value: message?.value ?? 1,
                type: message?.image == nil ? .primary : .content,
                width: message?.width ?? 100,
                isSentByCurrentUser: isSentByCurrentUser
            ),
            onDelete: { id in
                onDelete(id, isSentByCurrentUser)
                store.dispatch(.conversation(.deleteMessage(id)))
            }
        )
    }
}

enum MessageType {
    case primary, content
}

struct ChatMessage {
    let id: UUID
    let text: String
    let image: String?
    let value: Int
    let type: MessageType
    let width: CGFloat
    let isSentByCurrentUser: Bool
}

struct MessageSpacer: View {
    private var spacerWidth: CGFloat {
        UIScreen.main.bounds.width - 20 - 270
    }

    var body: some View {
        Spacer()
            .frame(minWidth: spacerWidth)
            .layoutPriority(-1)
    }
}

struct ConversationMessageContainer: View {
    let message: ChatMessage
    let onDelete: (UUID) -> Void

    var body: some View {
        HStack {
            if message.isSentByCurrentUser {
                MessageSpacer()
            }

            VStack(alignment: message.isSentByCurrentUser ? .trailing : .leading) {
                MessageView(
                    message: message,
                    primaryView: { _ in
                        MessageTextView(message: message) {
                            onDelete(message.id)
                        }
                    },
                    contentView: { _ in
                        MessageContentView(message: message) {
                            onDelete(message.id)
                        }
                    }
                )
                .padding(.vertical, 5)
            }

            if !message.isSentByCurrentUser {
                MessageSpacer()
            }
        }
    }
}

struct MessageView<
    PrimaryView: View,
    ContentView: View
>: View {
    let message: ChatMessage

    let primaryView: (UUID) -> PrimaryView
    let contentView: (UUID) -> ContentView

    var body: some View {
        switch message.type {
        case .primary:
            primaryView(message.id)
        case .content:
            contentView(message.id)
        }
    }
}

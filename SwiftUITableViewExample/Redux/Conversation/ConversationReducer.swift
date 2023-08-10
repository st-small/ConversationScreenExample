import Foundation

func ConversationReducer(state: inout ConversationState, action: ConversationAction) {
    switch action {
    case let .addMessageWithValue(value):
        state.messages.append(
            Message(
                id: UUID(),
                value: value,
                image: nil,
                width: CGFloat.random(in: 100...270),
                status: Int.random(in: 0...100).isMultiple(of: 2)
                ? .incoming : .outgoing
            )
        )
    case let .addMessage(message):
        state.messages.append(message)
    case let .deleteMessage(messageID):
        state.messages = state.messages.filter { $0.id != messageID }
    }
}

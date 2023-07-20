import Foundation

func ConversationReducer(state: inout ConversationState, action: ConversationAction) {
    switch action {
    case let .addMessage(value):
        state.messages.append(Message(id: UUID(), value: value))
    case let .deleteMessage(messageID):
        state.messages = state.messages.filter { $0.id != messageID }
    }
}

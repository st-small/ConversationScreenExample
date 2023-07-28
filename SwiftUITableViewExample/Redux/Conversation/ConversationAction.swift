import Foundation

public enum ConversationAction {
    case addMessageWithValue(Int)
    case addMessage(Message)
    case deleteMessage(UUID)
}

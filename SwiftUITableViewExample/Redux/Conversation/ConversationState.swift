import Foundation

public final class ConversationState: ObservableObject {
    @Published var messages: [Message] = []
}

struct Message: Hashable {
    let id: UUID
    let value: Int
    
    var content: String {
        "\(value)"
    }
}

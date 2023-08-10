import SwiftUI

public final class ConversationState: ObservableObject {
    @Published var messages: [Message] = []
}

enum MessageSendStatus {
    case incoming, outgoing
}

public struct Message: Hashable {
    let id: UUID
    let value: Int
    let image: String?
    let width: CGFloat
    let status: MessageSendStatus
    
    var content: String {
        "\(value)"
    }
}

extension Array where Element == Message {
    func firstMessageIndex(_ id: UUID) -> Int? {
        self.firstIndex(where: { $0.id == id })
    }
}

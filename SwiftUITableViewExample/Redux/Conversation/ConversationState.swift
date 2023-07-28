import SwiftUI

public final class ConversationState: ObservableObject {
    @Published var messages: [Message] = []
}

public struct Message: Hashable {
    let id: UUID
    let value: Int
    let image: String?
    let width: CGFloat
    
    var content: String {
        "\(value)"
    }
}

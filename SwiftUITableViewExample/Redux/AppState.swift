import Combine

public final class AppState: ObservableObject {
    @Published var conversation: ConversationState = .init()
}

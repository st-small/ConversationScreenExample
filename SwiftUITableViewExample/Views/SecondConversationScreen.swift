import SwiftUI

struct SecondConversationScreen: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var scrollViewSize: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        Spacer()
                        
                        ScrollView {
                            ForEach(store.state.conversation.messages, id: \.self) { message in
                                HStack {
                                    Spacer()
                                    MessageCellView(message: message)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .getSize { scrollViewSize = $0 }
                        }
                        .frame(height: scrollViewSize.height < geo.size.height ? scrollViewSize.height : .none)
                    }
                    .background(Color.blue.opacity(0.2))
                }
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 100)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Item") {
                        let random = Int.random(in: 500...7000000)
                        store.dispatch(.conversation(.addMessageWithValue(random)))
                    }
                }
            }
        }
    }
}

struct SecondConversationScreen_Previews: PreviewProvider {
    
    static var store: AppStore {
        let store = AppStore(
            initialState: .init(),
            reducer: appReducer)
        messagesData.forEach { message in
            store.dispatch(.conversation(.addMessage(message)))
        }
        return store
    }
    static var previews: some View {
        SecondConversationScreen()
            .environmentObject(store)
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }

    func body(content: Content) -> some View {
        content.overlay(sizeView)
    }
}

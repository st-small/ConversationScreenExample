import SwiftUI

struct UIKitConversationConnector: Connector {
    func map(store: AppStore) -> some View {
        UIKitConversationScreen(messages: store.state.conversation.messages)
    }
}

struct UIKitConversationScreen: View {
    
    let messages: [Message]
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @State private var text = ""
    
    var body: some View {
        VStack {
            ConversationListContainer(messages: messages)
            .background {
                Color.pink.opacity(0.3)
            }
            
            ZStack {
                VStack {
                    TextField("Enter text here ...", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Spacer()
                }
            }
            .frame(height: 100)
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(.default, value: keyboard.currentHeight)
        .navigationTitle("Conversation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add number") {
                    withAnimation {
                        let value = Int.random(in: 500...7000000)
                        store.dispatch(.conversation(.addMessageWithValue(value)))
                    }
                }
            }
        }
        .onChange(of: keyboard.currentHeight) { newValue in
            print("Keyboard height is \(newValue)")
        }
    }
}

struct UIKitConversationScreen_Previews: PreviewProvider {
    
    static var store: AppStore {
        let store = AppStore(initialState: .init(), reducer: appReducer)
        messagesData.forEach { store.dispatch(.conversation(.addMessage($0))) }
        
        return store
    }
    
    static var previews: some View {
        NavigationStack {
            UIKitConversationScreen(messages: messagesData)
        }
    }
}

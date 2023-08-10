import SwiftUI

struct ConversationScreenConnector: Connector {
    func map(store: AppStore) -> some View {
        let messages = store.state.conversation.messages
        print("There are \(messages.count) messages")
        
        return ConversationScreen(
            messages: messages,
            onAddMessage: { value in
                withAnimation {
                    store.dispatch(.conversation(.addMessageWithValue(value)))
                }
            },
            onDeleteMessage: { value in
                withAnimation {
                store.dispatch(.conversation(.deleteMessage(value))) }
            }
        )
    }
}

struct ConversationScreen: View {
    
    // MARK: - Props
    let messages: [Message]
    
    // MARK: - Command
    let onAddMessage: (Int) -> Void
    let onDeleteMessage: (UUID) -> Void
    
    @State private var text: String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    
    // View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollViewReader { reader in
                ScrollView {
                    // Для того что бы бы нормальный навигатион бар
                    Color.clear.frame(height: 1)
                    
                    VStack(spacing: 0) {
                        ForEach(messages, id: \.self) { message in
                            // Message Cell
                            HStack {
                                Spacer()
                                MessageCellView(message: message)
                            }
                        }
                    }
                    .onChange(of: messages.count) { newValue in
                        // при изменении скрол до последнего
                        withAnimation {
                            reader.scrollTo(messages[messages.count - 1])
                        }
                    }
                    .onAppear {
                        // При появлении скрол до последнего
                        reader.scrollTo(messages[messages.count - 1])
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear.onAppear { print(proxy.size.height) }
                        }
                    )
                }
                .background {
                    Color.cyan
                }
            }
            .onTapGesture {
                UIApplication.hideKeyboard()
            }
            
            VStack {
                TextField("Placeholder", text: $text)
                    .background(Color.white)
                    .padding()
                
                Spacer()
            }
            .frame(height: 100)
            .background(Color.red)
        }
        .navigationTitle("Messenger")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add number") {
                    onAddMessage(Int.random(in: 500...7000000))
                }
            }
        }
        // Это надо поднимать
        .offset(y: -keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.default, value: keyboard.currentHeight)
    }
}

struct ConversationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConversationScreen(
            messages: [
                Message(
                    id: UUID(),
                    value: 5,
                    image: nil,
                    width: 270,
                    status: .incoming),
                Message(
                    id: UUID(),
                    value: 0,
                    image: "one",
                    width: 300,
                    status: .outgoing)
            ],
            onAddMessage: { _ in },
            onDeleteMessage: { _ in }
        )
    }
}

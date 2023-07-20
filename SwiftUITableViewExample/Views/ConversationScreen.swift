import SwiftUI

struct ConversationScreenConnector: Connector {
    func map(store: AppStore) -> some View {
        let messages = store.state.conversation.messages
        print("There are \(messages.count) messages")
        
        return ConversationScreen(
            messages: messages,
            onAddMessage: { value in
                withAnimation {
                    store.dispatch(.conversation(.addMessage(value)))
                }
            },
            onDeleteMessage: { store.dispatch(.conversation(.deleteMessage($0))) }
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
        NavigationView {

            // тут надо было 0
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
                                    Text("Item \(message.content)")
                                    Spacer()
                                }
                                .frame(height: 70)
                                .background(color(fraction: Double(message.value) / 100))
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .contextMenu {
                                    Button("Replace") {
                                        onDeleteMessage(message.id)
                                    }
                                }
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .padding(15)
                                .id(message.id)
                                .transition(.move(edge: .trailing))
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
                        onAddMessage(Int.random(in: 500...700))
                    }
                }
            }
            // Это надо поднимать
            .offset(y: -keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default, value: keyboard.currentHeight)

        }
    }
    
    // Methods
    func color(fraction: Double) -> Color {
        Color(red: fraction, green: 1 - fraction, blue: 0.5)
            .opacity(0.3)
    }
}

struct ConversationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConversationScreen(
            messages: [
                Message(id: UUID(), value: 5)
            ],
            onAddMessage: { _ in },
            onDeleteMessage: { _ in }
        )
    }
}

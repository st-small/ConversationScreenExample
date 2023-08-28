import SwiftUI

struct ThirdConversationScreen: View {
    
    @State private var messages = messagesData
    
    var body: some View {
        List {
            ForEach(messages) { message in
                MessageInvstgCellView(message: message) { id in
                    if let idx = messages.firstIndex(where: { $0.id == id }) {
                        messages.remove(at: idx)
                    }
                }
            }
        }
    }
}

struct ThirdConversationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThirdConversationScreen()
    }
}

struct MessageInvstgCellView: View {
    
    // MARK: - Props
    let message: Message
    let onDelete: (UUID) -> Void
    
    var body: some View {
        Group {
            if let imageName = message.image {
                // Image message view
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(15)
                    .padding(5)
            } else {
                // Text message view
                HStack {
                    Spacer()
                    Text("Item \(message.content)")
                    Spacer()
                }
                .frame(height: 70)
            }
        }
        .frame(width: message.width)
        .background(Color.fraction(Double(message.value) / 100))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15, style: .continuous))
        .contextMenu {
            Button("Replace") {
                onDelete(message.id)
            }
        }
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .id(message.id)
        .transition(.move(edge: .trailing))
    }
}

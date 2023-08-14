import SwiftUI

struct MessageTextView: View {
    
    @EnvironmentObject var store: AppStore
    
    let message: ChatMessage
    let onDelete: () -> Void

    var body: some View {
        Text("Item \(message.text)")
        .frame(width: message.width, height: 70)
        .background(Color.fraction(Double(message.value) / 100))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15, style: .continuous))
        .contextMenu {
            Button("Replace") {
                onDelete()
                
                store.dispatch(.conversation(.deleteMessage(message.id)))
            }
        }
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.vertical, 5)
        .padding((message.isSentByCurrentUser ? .trailing : .horizontal), 15)
    }
}

struct MessageTextView_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextView(
            message: ChatMessage(
                id: messagesData[0].id,
                text: messagesData[0].content,
                image: nil,
                value: messagesData[0].value,
                type: .primary,
                width: messagesData[0].width,
                isSentByCurrentUser: true),
            onDelete: { }
        )
        .previewLayout(.sizeThatFits)
    }
}

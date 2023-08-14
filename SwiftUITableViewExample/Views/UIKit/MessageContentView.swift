import SwiftUI

struct MessageContentView: View {
    
    @EnvironmentObject var store: AppStore
    
    let message: ChatMessage
    let onDelete: () -> Void

    var body: some View {
        Image(message.image ?? "")
            .resizable()
            .scaledToFill()
            .cornerRadius(15)
            .padding(5)
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 15, style: .continuous))
            .contextMenu {
                Button("Replace") {
                    onDelete()
                    
                    store.dispatch(.conversation(.deleteMessage(message.id)))
                }
            }
        .frame(width: message.width)
        .background(Color.fraction(Double(message.value) / 100))
        .cornerRadius(15)
        .padding((message.isSentByCurrentUser ? .trailing : .leading), 15)
        .shadow(radius: 5)
        .padding(.vertical, 5)
    }
}

struct MessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageContentView(
            message: ChatMessage(
                id: messagesData[0].id,
                text: messagesData[0].content,
                image: messagesData[0].image,
                value: messagesData[0].value,
                type: .primary,
                width: messagesData[0].width,
                isSentByCurrentUser: true),
            onDelete: { }
        )
        .previewLayout(.sizeThatFits)
    }
}

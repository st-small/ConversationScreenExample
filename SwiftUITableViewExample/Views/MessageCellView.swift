import SwiftUI

struct MessageCellView: View {
    
    // MARK: - Props
    let message: Message
    
    @EnvironmentObject var store: AppStore
    
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
                store.dispatch(.conversation(.deleteMessage(message.id)))

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

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(
            message: messagesData[0]
        )
        .previewLayout(.sizeThatFits)
    }
}

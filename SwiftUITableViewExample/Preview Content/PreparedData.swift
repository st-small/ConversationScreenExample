import Foundation

let messagesData = [
    Message(id: UUID(), value: 0, image: "one", width: messageWidth),
    Message(id: UUID(), value: 5, image: nil, width: messageWidth),
    Message(id: UUID(), value: 0, image: "two", width: messageWidth),
    Message(id: UUID(), value: 3, image: nil, width: messageWidth),
    Message(id: UUID(), value: 0, image: "three", width: messageWidth),
    Message(id: UUID(), value: 7, image: nil, width: messageWidth)
]

private var messageWidth: CGFloat {
    CGFloat.random(in: 100...300)
}

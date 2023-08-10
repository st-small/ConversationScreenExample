import Foundation

let messagesData = [
    Message(id: UUID(), value: 0, image: "one", width: messageWidth, status: .incoming),
    Message(id: UUID(), value: 5, image: nil, width: messageWidth, status: .outgoing),
    Message(id: UUID(), value: 0, image: "two", width: messageWidth, status: .incoming),
    Message(id: UUID(), value: 3, image: nil, width: messageWidth, status: .outgoing),
    Message(id: UUID(), value: 0, image: "three", width: messageWidth, status: .incoming),
    Message(id: UUID(), value: 7, image: nil, width: messageWidth, status: .outgoing)
]

private var messageWidth: CGFloat {
    CGFloat.random(in: 100...250)
}

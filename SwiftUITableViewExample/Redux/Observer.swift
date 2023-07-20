import Foundation

final class Observer<State>: Hashable {
    let queue: DispatchQueue
    let observe: (State) -> Void

    init(queue: DispatchQueue, observe: @escaping (State) -> Void) {
        self.queue = queue
        self.observe = observe
    }

    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }

    static func == (lhs: Observer<State>, rhs: Observer<State>) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

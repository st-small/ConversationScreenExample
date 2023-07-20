import Foundation

import Combine
import Foundation

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>?
public typealias AppStore = Store<AppState, AppAction>

public final class Store<State, Action>: ObservableObject {
    // Read only access to app state
    @Published private(set) var state: State

    var tasks = [AnyCancellable]()
    private let reducer: Reducer<State, Action>
    let middlewares: [Middleware<State, Action>]
    private var middlewareCancellables: Set<AnyCancellable> = []

    init(initialState: State,
         reducer: @escaping Reducer<State, Action>,
         middlewares: [Middleware<State, Action>] = [])
    {
        state = initialState
        self.reducer = reducer
        self.middlewares = middlewares
    }

    // The dispatch function.
    func dispatch(_ action: Action) {
        /// Отлавливание событий, отправленных из фоновых потоков
        /// Пусть какое-то вермя повисит
        guard Thread.isMainThread else { preconditionFailure("*** \(action)") }
        ///

        reducer(&state, action)

        // Dispatch all middleware functions
        for mw in middlewares {
            guard let middleware = mw(state, action) else {
                break
            }
            middleware
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &middlewareCancellables)
        }

        // Dispatch all observers
        queue.async {
            self.observers.forEach(self.notify)
        }
    }

    // Observers
    private let queue = DispatchQueue(label: "Store queue", qos: .userInitiated)
    private var observers: Set<Observer<State>> = []

    func subscribe(_ observer: Observer<State>) {
        queue.async {
            self.observers.insert(observer)
            self.notify(observer)
        }
    }

    private func notify(_ observer: Observer<State>) {
        observer.observe(state)
    }
}

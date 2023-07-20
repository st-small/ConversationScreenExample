import Foundation

typealias Reducer<State, Action> = (inout State, Action) -> Void

func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    case let .conversation(action):
        ConversationReducer(state: &state.conversation, action: action)
    }
}

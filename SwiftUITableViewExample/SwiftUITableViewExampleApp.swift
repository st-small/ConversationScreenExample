import SwiftUI

let store = AppStore(
    initialState: .init(),
    reducer: appReducer)

@main
struct SwiftUITableViewExampleApp: App {
    
    init() {
        store.dispatch(.conversation(.addMessage(5)))
        store.dispatch(.conversation(.addMessage(7)))
        store.dispatch(.conversation(.addMessage(9)))
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .white
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ConversationScreenConnector()
                .environmentObject(store)
        }
    }
}

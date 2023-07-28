import SwiftUI

let store = AppStore(
    initialState: .init(),
    reducer: appReducer)

@main
struct SwiftUITableViewExampleApp: App {
    
    init() {
        prepareInitialData()
        
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
    
    private func prepareInitialData() {
        messagesData.forEach { store.dispatch(.conversation(.addMessage($0))) }
    }
}

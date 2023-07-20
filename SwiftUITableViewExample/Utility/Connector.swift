import SwiftUI

protocol Connector: View {
    associatedtype Content: View
    func map(store: AppStore) -> Content
}

extension Connector {
    var body: some View {
        Connected<Content>(map: map)
    }
}

private struct Connected<V: View>: View {
    @EnvironmentObject var store: AppStore

    let map: (AppStore) -> V

    var body: V {
        map(store)
    }
}

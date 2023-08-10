import SwiftUI

extension View {
    func measure() -> some View {
        overlay(GeometryReader { proxy in
            Text("\(Int(proxy.size.width)) × \(Int(proxy.size.height))")
                .foregroundColor(.white)
                .background(.black)
                .font(.footnote)
        })
    }
}

extension View {
    func getSize(perform: @escaping (CGSize) -> ()) -> some View {
        self
            .modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                perform($0)
            }
    }
}

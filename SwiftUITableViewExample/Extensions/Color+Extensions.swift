import SwiftUI

extension Color {
    static func fraction(_ fraction: Double) -> Color {
        Color(red: fraction, green: 1 - fraction, blue: 0.5)
            .opacity(0.3)
    }
}

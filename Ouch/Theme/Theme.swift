import SwiftUI

enum FY {
    // MARK: - Colors (warm, cozy, notebook-paper vibe)

    static let background = Color(red: 1.0, green: 0.97, blue: 0.94)       // warm cream
    static let card = Color.white
    static let surface = Color(red: 0.97, green: 0.94, blue: 0.90)          // soft tan
    static let accent = Color(red: 0.42, green: 0.35, blue: 0.80)           // soft indigo
    static let success = Color(red: 0.35, green: 0.73, blue: 0.44)          // sage green
    static let warning = Color(red: 0.95, green: 0.68, blue: 0.25)          // warm amber
    static let danger = Color(red: 0.90, green: 0.36, blue: 0.36)           // soft coral-red
    static let textPrimary = Color(red: 0.17, green: 0.14, blue: 0.13)      // dark brown
    static let textSecondary = Color(red: 0.55, green: 0.48, blue: 0.42)    // warm gray
    static let textTertiary = Color(red: 0.72, green: 0.66, blue: 0.60)     // light warm gray

    // MARK: - Gradients

    static let accentGradient = LinearGradient(
        colors: [Color(red: 0.42, green: 0.35, blue: 0.80), Color(red: 0.58, green: 0.42, blue: 0.82)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let successGradient = LinearGradient(
        colors: [Color(red: 0.35, green: 0.73, blue: 0.44), Color(red: 0.40, green: 0.78, blue: 0.58)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let dangerGradient = LinearGradient(
        colors: [Color(red: 0.90, green: 0.36, blue: 0.36), Color(red: 0.85, green: 0.28, blue: 0.38)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let warmGradient = LinearGradient(
        colors: [Color(red: 0.95, green: 0.68, blue: 0.25), Color(red: 0.95, green: 0.52, blue: 0.30)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let mutedGradient = LinearGradient(
        colors: [Color(white: 0.78), Color(white: 0.68)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    // MARK: - Corner Radius

    static let radiusS: CGFloat = 12
    static let radiusM: CGFloat = 18
    static let radiusL: CGFloat = 26

    // MARK: - Spacing

    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 16
    static let spacingL: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48

    // MARK: - Shadow

    static let cardShadow = Color.black.opacity(0.06)
}

// MARK: - View Modifiers

struct FYBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(FY.background.ignoresSafeArea())
    }
}

extension View {
    func fyBackground() -> some View {
        modifier(FYBackground())
    }
}

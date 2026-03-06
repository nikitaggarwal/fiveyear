import SwiftUI

struct GlassCard<Content: View>: View {
    var padding: CGFloat = FY.spacingL
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: FY.radiusL, style: .continuous)
                    .fill(FY.card)
                    .shadow(color: FY.cardShadow, radius: 8, y: 3)
            )
    }
}

#Preview {
    GlassCard {
        Text("Hello World")
            .foregroundStyle(FY.textPrimary)
    }
    .padding()
    .fyBackground()
}

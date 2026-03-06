import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String
    let gradient: LinearGradient
    var isLarge: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FY.spacingS) {
                Image(systemName: icon)
                    .font(isLarge ? .title2 : .body)
                    .fontWeight(.semibold)
                Text(title)
                    .font(isLarge ? .title3 : .body)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, isLarge ? 20 : 16)
            .background(
                RoundedRectangle(cornerRadius: FY.radiusM, style: .continuous)
                    .fill(gradient)
            )
            .shadow(color: .black.opacity(0.10), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        ActionButton(title: "I'm Up!", icon: "sun.max.fill", gradient: FY.successGradient, isLarge: true, action: {})
        ActionButton(title: "$5 for 5 min", icon: "dollarsign.circle.fill", gradient: FY.dangerGradient, action: {})
    }
    .padding()
    .fyBackground()
}

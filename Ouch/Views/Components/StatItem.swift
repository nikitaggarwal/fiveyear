import SwiftUI

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    var color: Color = FY.accent

    var body: some View {
        VStack(spacing: FY.spacingXS) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title.bold())
                .fontDesign(.rounded)
                .foregroundStyle(FY.textPrimary)
            Text(label)
                .font(.caption)
                .fontDesign(.rounded)
                .foregroundStyle(FY.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HStack {
        StatItem(value: "$10", label: "Spent", icon: "dollarsign.circle", color: FY.danger)
        StatItem(value: "5", label: "Streak", icon: "flame.fill", color: FY.warning)
    }
    .padding()
    .fyBackground()
}

import SwiftUI

struct DayPicker: View {
    @Binding var selectedDays: Set<Int>

    private let days: [(id: Int, label: String)] = [
        (1, "S"), (2, "M"), (3, "T"), (4, "W"), (5, "T"), (6, "F"), (7, "S"),
    ]

    var body: some View {
        HStack(spacing: FY.spacingS) {
            ForEach(days, id: \.id) { day in
                let isSelected = selectedDays.contains(day.id)
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        if isSelected { selectedDays.remove(day.id) }
                        else { selectedDays.insert(day.id) }
                    }
                } label: {
                    Text(day.label)
                        .font(.caption.bold())
                        .fontDesign(.rounded)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(isSelected ? FY.accent : FY.surface)
                        )
                        .foregroundStyle(isSelected ? .white : FY.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    DayPicker(selectedDays: .constant([2, 3, 4, 5, 6]))
        .padding()
        .fyBackground()
}

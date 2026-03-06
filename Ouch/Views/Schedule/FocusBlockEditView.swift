import SwiftUI

struct FocusBlockEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var block = FocusBlock()
    let onSave: (FocusBlock) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: FY.spacingL) {

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Name", systemImage: "pencil")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            TextField("Focus block name", text: $block.name)
                                .textFieldStyle(.plain)
                                .font(.title3).fontDesign(.rounded)
                                .foregroundStyle(FY.textPrimary)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: FY.radiusS, style: .continuous)
                                        .fill(FY.surface)
                                )
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Start Time", systemImage: "clock")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            DatePicker("", selection: $block.startDate, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120).clipped()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("End Time", systemImage: "clock.badge.checkmark")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            DatePicker("", selection: $block.endDate, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .frame(height: 120).clipped()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Active Days", systemImage: "calendar")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            DayPicker(selectedDays: $block.activeDays)
                        }
                    }
                }
                .padding(FY.spacingL)
            }
            .navigationTitle("New Focus Block")
            .navigationBarTitleDisplayMode(.inline)
            .fyBackground()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(FY.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(block)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(FY.accent)
                    .disabled(block.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    FocusBlockEditView { _ in }
}

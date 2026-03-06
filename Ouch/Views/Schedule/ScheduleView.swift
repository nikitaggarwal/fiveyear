import SwiftUI

struct ScheduleView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var showAddBlock = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: FY.spacingL) {

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Wake Up", systemImage: "sunrise.fill")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.warning)

                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { appState.schedule.wakeUpDate },
                                    set: {
                                        var s = appState.schedule
                                        s.wakeUpDate = $0
                                        appState.schedule = s
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 120)
                            .clipped()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Bedtime", systemImage: "moon.fill")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.accent)

                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { appState.schedule.bedtimeDate },
                                    set: {
                                        var s = appState.schedule
                                        s.bedtimeDate = $0
                                        appState.schedule = s
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 120)
                            .clipped()
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            HStack {
                                Label("Focus Blocks", systemImage: "lock.fill")
                                    .font(.headline).fontDesign(.rounded)
                                    .foregroundStyle(FY.accent)
                                Spacer()
                                Button { showAddBlock = true } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(FY.accent)
                                }
                            }

                            if appState.schedule.focusBlocks.isEmpty {
                                Text("No focus blocks yet")
                                    .font(.subheadline).fontDesign(.rounded)
                                    .foregroundStyle(FY.textTertiary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, FY.spacingM)
                            } else {
                                ForEach(appState.schedule.focusBlocks) { block in
                                    FocusBlockRow(block: block) {
                                        var s = appState.schedule
                                        s.focusBlocks.removeAll { $0.id == block.id }
                                        appState.schedule = s
                                    }
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Morning Grace Period", systemImage: "timer")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            HStack {
                                Text("\(appState.schedule.gracePeriodMinutes) min")
                                    .font(.title3.bold()).fontDesign(.rounded)
                                    .foregroundStyle(FY.textPrimary)
                                    .frame(width: 70, alignment: .leading)

                                Slider(
                                    value: Binding(
                                        get: { Double(appState.schedule.gracePeriodMinutes) },
                                        set: {
                                            var s = appState.schedule
                                            s.gracePeriodMinutes = Int($0)
                                            appState.schedule = s
                                        }
                                    ),
                                    in: 1...30, step: 1
                                )
                                .tint(FY.accent)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Active Days", systemImage: "calendar.badge.clock")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            DayPicker(
                                selectedDays: Binding(
                                    get: { appState.schedule.activeDays },
                                    set: {
                                        var s = appState.schedule
                                        s.activeDays = $0
                                        appState.schedule = s
                                    }
                                )
                            )
                        }
                    }
                }
                .padding(FY.spacingL)
            }
            .navigationTitle("Schedule")
            .fyBackground()
            .sheet(isPresented: $showAddBlock) {
                FocusBlockEditView { block in
                    var s = appState.schedule
                    s.focusBlocks.append(block)
                    appState.schedule = s
                }
            }
        }
    }
}

struct FocusBlockRow: View {
    let block: FocusBlock
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(block.name)
                    .font(.subheadline.bold()).fontDesign(.rounded)
                    .foregroundStyle(FY.textPrimary)
                Text(block.formattedTimeRange)
                    .font(.caption).fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }
            Spacer()
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
                    .font(.subheadline)
                    .foregroundStyle(FY.danger.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, FY.spacingXS)
    }
}

#Preview {
    ScheduleView()
        .environment(AppStateManager())
}

import SwiftData
import SwiftUI

struct StatsView: View {
    @Environment(AppStateManager.self) private var appState
    @Query(sort: \PenaltyEvent.timestamp, order: .reverse) private var penalties: [PenaltyEvent]

    private var thisWeekPenalties: [PenaltyEvent] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return penalties.filter { $0.timestamp > weekAgo }
    }

    private var todayPenalties: [PenaltyEvent] {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        return penalties.filter { $0.timestamp > startOfDay }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: FY.spacingL) {

                    HStack(spacing: FY.spacingM) {
                        SummaryCard(title: "Today", value: "$\(Int(todayPenalties.reduce(0) { $0 + $1.amount }))", icon: "clock.fill", color: FY.accent)
                        SummaryCard(title: "This Week", value: "$\(Int(thisWeekPenalties.reduce(0) { $0 + $1.amount }))", icon: "calendar", color: FY.warning)
                    }

                    HStack(spacing: FY.spacingM) {
                        SummaryCard(title: "All Time", value: "$\(Int(penalties.reduce(0) { $0 + $1.amount }))", icon: "dollarsign.circle.fill", color: FY.danger)
                        SummaryCard(title: "Streak", value: "\(appState.currentStreak)", icon: "flame.fill", color: FY.success)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: FY.spacingM) {
                            Label("Recent Penalties", systemImage: "list.bullet")
                                .font(.headline).fontDesign(.rounded)
                                .foregroundStyle(FY.textSecondary)

                            if penalties.isEmpty {
                                VStack(spacing: FY.spacingS) {
                                    Image("celebrate")
                                        .resizable().scaledToFit()
                                        .frame(width: 80, height: 80)
                                    Text("No penalties yet — keep it up!")
                                        .font(.subheadline).fontDesign(.rounded)
                                        .foregroundStyle(FY.textTertiary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, FY.spacingL)
                            } else {
                                ForEach(Array(penalties.prefix(20)), id: \.timestamp) { event in
                                    PenaltyRow(event: event)
                                    if event.timestamp != penalties.prefix(20).last?.timestamp {
                                        Divider().overlay(FY.surface)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(FY.spacingL)
            }
            .navigationTitle("Stats")
            .fyBackground()
        }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        GlassCard(padding: FY.spacingM) {
            VStack(alignment: .leading, spacing: FY.spacingS) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                Text(value)
                    .font(.title.bold()).fontDesign(.rounded)
                    .foregroundStyle(FY.textPrimary)
                Text(title)
                    .font(.caption).fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }
        }
    }
}

private struct PenaltyRow: View {
    let event: PenaltyEvent

    var body: some View {
        HStack {
            let ctx = PenaltyContext(rawValue: event.context)
            Image(systemName: ctx?.icon ?? "questionmark.circle")
                .font(.title3)
                .foregroundStyle(FY.danger)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(ctx?.displayName ?? event.context.capitalized)
                    .font(.subheadline.bold()).fontDesign(.rounded)
                    .foregroundStyle(FY.textPrimary)
                Text(event.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption).fontDesign(.rounded)
                    .foregroundStyle(FY.textTertiary)
            }

            Spacer()

            Text("-$\(Int(event.amount))")
                .font(.subheadline.bold()).fontDesign(.rounded)
                .foregroundStyle(FY.danger)
        }
        .padding(.vertical, FY.spacingXS)
    }
}

#Preview {
    StatsView()
        .environment(AppStateManager())
        .modelContainer(for: PenaltyEvent.self, inMemory: true)
}

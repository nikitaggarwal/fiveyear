import SwiftData
import SwiftUI

struct FreeTimeView: View {
    let now: Date
    @Environment(AppStateManager.self) private var appState
    @Query(sort: \PenaltyEvent.timestamp, order: .reverse) private var penalties: [PenaltyEvent]
    @State private var animateIn = false

    private var todaySpent: Int {
        let startOfDay = Calendar.current.startOfDay(for: .now)
        return Int(penalties.filter { $0.timestamp > startOfDay }.reduce(0) { $0 + $1.amount })
    }

    var body: some View {
        VStack(spacing: FY.spacingXL) {
            Spacer()

            Image("celebrate")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .opacity(animateIn ? 1 : 0)
                .scaleEffect(animateIn ? 1 : 0.7)

            VStack(spacing: FY.spacingS) {
                Text("You're Free!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(FY.textPrimary)

                Text(nextBlockText)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 16)

            Spacer()

            GlassCard {
                VStack(spacing: FY.spacingM) {
                    HStack {
                        Label("Today", systemImage: "calendar")
                            .font(.headline)
                            .fontDesign(.rounded)
                            .foregroundStyle(FY.textSecondary)
                        Spacer()
                    }

                    HStack(spacing: FY.spacingXL) {
                        StatItem(value: "$\(todaySpent)", label: "Spent", icon: "dollarsign.circle", color: FY.danger)
                        StatItem(value: "\(appState.currentStreak)", label: "Day Streak", icon: "flame.fill", color: FY.warning)
                    }
                }
            }
            .padding(.horizontal, FY.spacingL)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 24)

            Spacer().frame(height: FY.spacingXXL)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8).delay(0.1)) {
                animateIn = true
            }
        }
    }

    private var nextBlockText: String {
        let cal = Calendar.current
        let curMins = cal.component(.hour, from: now) * 60 + cal.component(.minute, from: now)
        let bedMins = appState.schedule.bedtimeHour * 60 + appState.schedule.bedtimeMinute
        var nextDelta = bedMins > curMins ? bedMins - curMins : bedMins + 1440 - curMins
        var nextTime = bedMins
        var nextName = "Bedtime"

        let today = cal.component(.weekday, from: now)
        for block in appState.schedule.focusBlocks {
            guard block.activeDays.contains(today) else { continue }
            let startMins = block.startHour * 60 + block.startMinute
            let delta = startMins > curMins ? startMins - curMins : startMins + 1440 - curMins
            if delta < nextDelta {
                nextDelta = delta
                nextTime = startMins
                nextName = block.name
            }
        }

        let h = nextTime / 60
        let m = nextTime % 60
        let displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h)
        let suffix = h >= 12 ? "PM" : "AM"
        return "\(nextName) at \(displayH):\(String(format: "%02d", m)) \(suffix)"
    }
}

#Preview {
    FreeTimeView(now: .now)
        .fyBackground()
        .environment(AppStateManager())
}

import SwiftUI

struct BreakView: View {
    let unlockEnd: Date
    let now: Date

    @Environment(AppStateManager.self) private var appState

    private var secondsRemaining: Int {
        max(Int(unlockEnd.timeIntervalSince(now)), 0)
    }

    private var progress: Double {
        let total = Double(appState.unlockDurationMinutes) * 60
        guard total > 0 else { return 0 }
        return 1.0 - Double(secondsRemaining) / total
    }

    private var timeRemainingText: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return m > 0 ? "\(m)m \(s)s" : "\(s)s"
    }

    var body: some View {
        VStack(spacing: FY.spacingXL) {
            Spacer()

            ZStack {
                CircularProgress(
                    progress: progress,
                    lineWidth: 10,
                    size: 220,
                    trackColor: FY.surface,
                    progressColor: FY.warning
                )

                VStack(spacing: FY.spacingS) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 40))
                        .foregroundStyle(FY.warning)

                    Text(timeRemainingText)
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundStyle(FY.textPrimary)
                        .contentTransition(.numericText())

                    Text("remaining")
                        .font(.caption)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textSecondary)
                }
            }

            VStack(spacing: FY.spacingXS) {
                Text("On Break")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(FY.textPrimary)

                Text("apps unblocked temporarily")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }

            Spacer()

            Text("-$\(Int(appState.penaltyAmount))")
                .font(.title2.bold()).fontDesign(.rounded)
                .foregroundStyle(FY.danger)
                .padding(.horizontal, FY.spacingL)
                .padding(.vertical, FY.spacingS)
                .background(Capsule().fill(FY.danger.opacity(0.1)))

            Spacer().frame(height: FY.spacingXXL)
        }
    }
}

#Preview {
    BreakView(unlockEnd: Date.now.addingTimeInterval(300), now: .now)
        .fyBackground()
        .environment(AppStateManager())
}

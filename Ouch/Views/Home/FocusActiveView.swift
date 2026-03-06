import SwiftData
import SwiftUI

struct FocusActiveView: View {
    let blockName: String
    let endHour: Int
    let endMinute: Int
    let now: Date

    @Environment(AppStateManager.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @State private var showVenmoConfirm = false

    private static let genericNotes = [
        "caught scrolling again lol",
        "no self control tax",
        "doomscroll fee",
        "weak moment surcharge",
        "screen time walk of shame",
        "brain rot bailout",
        "couldn't resist the reels",
    ]

    private static func focusNotes(for name: String) -> [String] {
        let n = name.lowercased()
        return [
            "couldn't survive \(n) without my phone",
            "folded during \(n)",
            "broke out of \(n) like a prison escape",
            "\(n)? more like scroll time",
            "paid to escape \(n)",
            "surrendered during \(n)",
            "\(n) was too hard apparently",
            "couldn't handle \(n) lol",
        ]
    }

    private var venmoNote: String {
        let isFirstUnlock = !UserDefaults.shared.bool(forKey: "hasUnlockedBefore")
        if isFirstUnlock {
            UserDefaults.shared.set(true, forKey: "hasUnlockedBefore")
            return "ouch that hurt my wallet"
        }
        // ~40% chance for the signature note
        if Int.random(in: 0..<5) < 2 { return "ouch that hurt my wallet" }
        let all = Self.genericNotes + Self.focusNotes(for: blockName)
        return all.randomElement() ?? Self.genericNotes[0]
    }

    private var progress: Double {
        let cal = Calendar.current
        let curSecs = cal.component(.hour, from: now) * 3600
            + cal.component(.minute, from: now) * 60
            + cal.component(.second, from: now)
        var endSecs = endHour * 3600 + endMinute * 60
        if let block = appState.schedule.focusBlocks.first(where: {
            $0.endHour == endHour && $0.endMinute == endMinute
        }) {
            let startSecs = block.startHour * 3600 + block.startMinute * 60
            if endSecs <= startSecs { endSecs += 86400 }
            let total = endSecs - startSecs
            guard total > 0 else { return 0 }
            let cur = curSecs < startSecs ? curSecs + 86400 : curSecs
            return Double(cur - startSecs) / Double(total)
        }
        return 0
    }

    private var timeRemaining: String {
        let cal = Calendar.current
        let curMin = cal.component(.hour, from: now) * 60 + cal.component(.minute, from: now)
        var endMin = endHour * 60 + endMinute
        if endMin <= curMin && endMin < 720 { endMin += 1440 }
        let remaining = max(endMin - curMin, 0)
        let h = remaining / 60
        let m = remaining % 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }

    private var endTimeFormatted: String {
        let h = endHour > 12 ? endHour - 12 : (endHour == 0 ? 12 : endHour)
        let suffix = endHour >= 12 ? "PM" : "AM"
        return "\(h):\(String(format: "%02d", endMinute)) \(suffix)"
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
                    progressColor: FY.accent
                )

                VStack(spacing: FY.spacingS) {
                    Image("lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)

                    Text(timeRemaining)
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
                Text(blockName)
                    .font(.title2.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textPrimary)

                Text("Ends at \(endTimeFormatted)")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }

            Spacer()

            if appState.currentStreak > 0 {
                HStack(spacing: FY.spacingS) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(FY.warning)
                    Text("\(appState.currentStreak) day streak")
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .foregroundStyle(FY.textSecondary)
                }
                .padding(.horizontal, FY.spacingM)
                .padding(.vertical, FY.spacingS)
                .background(Capsule().fill(FY.surface))
            }

            ActionButton(
                title: "$\(Int(appState.penaltyAmount)) for \(appState.unlockDurationMinutes) min",
                icon: "dollarsign.circle.fill",
                gradient: FY.dangerGradient
            ) {
                showVenmoConfirm = true
            }
            .padding(.horizontal, FY.spacingL)

            Spacer().frame(height: FY.spacingL)
        }
        .alert("Open Venmo?", isPresented: $showVenmoConfirm) {
            Button("Pay & Unlock", role: .destructive) {
                VenmoService.pay(
                    username: appState.venmoUsername,
                    amount: appState.penaltyAmount,
                    note: venmoNote
                )
                let event = PenaltyEvent(
                    context: PenaltyContext.focus.rawValue,
                    amount: appState.penaltyAmount,
                    unlockDurationMinutes: appState.unlockDurationMinutes,
                    venmoRecipient: appState.venmoUsername
                )
                modelContext.insert(event)
                ScreenTimeManager.shared.temporaryUnlock(
                    seconds: Double(appState.unlockDurationMinutes) * 60
                )
                appState.grantTemporaryUnlock()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "Pay $\(Int(appState.penaltyAmount)) to @\(appState.venmoUsername) to unlock for \(appState.unlockDurationMinutes) min."
            )
        }
    }
}

#Preview {
    FocusActiveView(blockName: "Deep Work", endHour: 12, endMinute: 0, now: .now)
        .fyBackground()
        .environment(AppStateManager())
}

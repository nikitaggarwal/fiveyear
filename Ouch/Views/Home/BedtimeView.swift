import SwiftUI

struct BedtimeView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var showVenmoConfirm = false
    @State private var animateIn = false

    var body: some View {
        VStack(spacing: FY.spacingXL) {
            Spacer()

            Image("moon")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .opacity(animateIn ? 1 : 0)
                .scaleEffect(animateIn ? 1 : 0.7)

            VStack(spacing: FY.spacingS) {
                Text("Bedtime")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(FY.textPrimary)

                Text("Social media is blocked")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)

                Text("until \(wakeUpFormatted)")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textTertiary)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 16)

            Spacer()

            ActionButton(
                title: "$\(Int(appState.penaltyAmount)) for \(appState.unlockDurationMinutes) min",
                icon: "dollarsign.circle.fill",
                gradient: FY.dangerGradient
            ) {
                showVenmoConfirm = true
            }
            .padding(.horizontal, FY.spacingL)
            .opacity(animateIn ? 1 : 0)

            Spacer().frame(height: FY.spacingXXL)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8).delay(0.15)) {
                animateIn = true
            }
        }
        .alert("Open Venmo?", isPresented: $showVenmoConfirm) {
            Button("Pay & Unlock", role: .destructive) {
                VenmoService.pay(
                    username: appState.venmoUsername,
                    amount: appState.penaltyAmount,
                    note: "Ouch bedtime penalty"
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

    private var wakeUpFormatted: String {
        let h = appState.schedule.wakeUpHour
        let m = appState.schedule.wakeUpMinute
        let displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h)
        let suffix = h >= 12 ? "PM" : "AM"
        return "\(displayH):\(String(format: "%02d", m)) \(suffix)"
    }
}

#Preview {
    BedtimeView()
        .fyBackground()
        .environment(AppStateManager())
}

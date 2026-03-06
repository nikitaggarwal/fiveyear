import SwiftUI

struct MorningView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var showVenmoConfirm = false
    @State private var animateIn = false

    var body: some View {
        VStack(spacing: FY.spacingXL) {
            Spacer()

            Image("sunrise")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(animateIn ? 1 : 0)
                .scaleEffect(animateIn ? 1 : 0.7)

            VStack(spacing: FY.spacingS) {
                Text("Good Morning")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(FY.textPrimary)

                Text(Date.now.formatted(date: .omitted, time: .shortened))
                    .font(.title2)
                    .fontDesign(.rounded)
                    .foregroundStyle(FY.textSecondary)
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 16)

            Spacer()

            VStack(spacing: FY.spacingM) {
                ActionButton(
                    title: "I'm Up!",
                    icon: "sun.max.fill",
                    gradient: FY.successGradient,
                    isLarge: true
                ) {
                    withAnimation(.spring(duration: 0.5)) {
                        appState.confirmAwake()
                    }
                }

                ActionButton(
                    title: "$\(Int(appState.penaltyAmount)) for \(appState.unlockDurationMinutes) min of scrolling",
                    icon: "dollarsign.circle.fill",
                    gradient: FY.dangerGradient
                ) {
                    showVenmoConfirm = true
                }
            }
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 24)

            Spacer().frame(height: FY.spacingXL)
        }
        .padding(.horizontal, FY.spacingL)
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
                    note: "Ouch morning penalty"
                )
                appState.grantTemporaryUnlock()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "You'll be sent to Venmo to pay $\(Int(appState.penaltyAmount)) to @\(appState.venmoUsername). Social media unlocks for \(appState.unlockDurationMinutes) min."
            )
        }
    }
}

#Preview {
    MorningView()
        .fyBackground()
        .environment(AppStateManager())
}

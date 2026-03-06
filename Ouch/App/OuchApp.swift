import SwiftData
import SwiftUI

@main
struct OuchApp: App {
    @State private var appState = AppStateManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environment(appState)
            .preferredColorScheme(.light)
        }
        .modelContainer(for: PenaltyEvent.self)
    }
}

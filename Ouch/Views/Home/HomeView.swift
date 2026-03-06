import SwiftUI

struct HomeView: View {
    @Environment(AppStateManager.self) private var appState
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            FY.background.ignoresSafeArea()

            switch appState.currentTimeState(at: now) {
            case .morning:
                MorningView()
            case .focus(let name, let endH, let endM):
                FocusActiveView(blockName: name, endHour: endH, endMinute: endM, now: now)
            case .bedtime:
                BedtimeView()
            case .free:
                FreeTimeView(now: now)
            }
        }
        .onReceive(timer) { now = $0 }
    }
}

#Preview {
    HomeView()
        .environment(AppStateManager())
}

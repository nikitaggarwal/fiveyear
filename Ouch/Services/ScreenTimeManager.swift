import Foundation
import os

#if canImport(FamilyControls)
import FamilyControls
import ManagedSettings
#endif

@Observable
@MainActor
final class ScreenTimeManager {
    static let shared = ScreenTimeManager()

    var isAuthorized = false
    var isRequestingAuth = false
    var authError: String?

    #if canImport(FamilyControls)
    private let store = ManagedSettingsStore()
    var activitySelection = FamilyActivitySelection()
    #endif

    private init() {
        #if canImport(FamilyControls)
        isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
        #endif
    }

    func requestAuthorization() {
        #if canImport(FamilyControls)
        isRequestingAuth = true
        authError = nil
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                await MainActor.run {
                    isAuthorized = true
                    isRequestingAuth = false
                }
            } catch {
                Logger.screenTime.error("FamilyControls auth failed: \(error.localizedDescription)")
                await MainActor.run {
                    authError = error.localizedDescription
                    isRequestingAuth = false
                }
            }
        }
        #else
        Logger.screenTime.warning("FamilyControls not available on this platform")
        #endif
    }

    func applyShields() {
        #if canImport(FamilyControls)
        store.shield.applications = activitySelection.applicationTokens.isEmpty ? nil : activitySelection.applicationTokens
        store.shield.applicationCategories = activitySelection.categoryTokens.isEmpty
            ? nil
            : .specific(activitySelection.categoryTokens)
        Logger.screenTime.info("Shields applied to \(self.activitySelection.applicationTokens.count) apps")
        #endif
    }

    func unshieldApps() {
        #if canImport(FamilyControls)
        store.clearAllSettings()
        Logger.screenTime.info("Shields removed")
        #endif
    }

    func temporaryUnlock(seconds: TimeInterval) {
        unshieldApps()
        Task {
            try? await Task.sleep(for: .seconds(seconds))
            await MainActor.run { applyShields() }
        }
    }
}

extension Logger {
    static let screenTime = Logger(subsystem: "com.ouchapp.app", category: "ScreenTime")
}

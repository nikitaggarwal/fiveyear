import SwiftUI

@Observable
final class AppStateManager {

    // MARK: - Persisted Settings

    var hasCompletedOnboarding: Bool = UserDefaults.shared.bool(forKey: "hasCompletedOnboarding") {
        didSet { UserDefaults.shared.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }

    var venmoUsername: String = UserDefaults.shared.string(forKey: "venmoUsername") ?? "" {
        didSet { UserDefaults.shared.set(venmoUsername, forKey: "venmoUsername") }
    }

    var penaltyAmount: Double = {
        let v = UserDefaults.shared.double(forKey: "penaltyAmount")
        return v > 0 ? v : 5.0
    }() {
        didSet { UserDefaults.shared.set(penaltyAmount, forKey: "penaltyAmount") }
    }

    var unlockDurationMinutes: Int = {
        let v = UserDefaults.shared.integer(forKey: "unlockDurationMinutes")
        return v > 0 ? v : 5
    }() {
        didSet { UserDefaults.shared.set(unlockDurationMinutes, forKey: "unlockDurationMinutes") }
    }

    // MARK: - Schedule

    var schedule: Schedule = Schedule.load() {
        didSet { schedule.save() }
    }

    // MARK: - Runtime State

    var hasConfirmedAwakeToday: Bool = false
    var temporaryUnlockEnd: Date? = nil
    var currentStreak: Int = 0

    var isTemporarilyUnlocked: Bool {
        guard let end = temporaryUnlockEnd else { return false }
        return Date.now < end
    }

    // MARK: - Computed Time State

    func currentTimeState(at date: Date = .now) -> TimeState {
        if isTemporarilyUnlocked, let end = temporaryUnlockEnd {
            return .onBreak(unlockEnd: end)
        }

        let cal = Calendar.current
        let mins = cal.component(.hour, from: date) * 60 + cal.component(.minute, from: date)
        let wake = schedule.wakeUpHour * 60 + schedule.wakeUpMinute
        let bed  = schedule.bedtimeHour * 60 + schedule.bedtimeMinute

        if !hasConfirmedAwakeToday && mins >= wake && mins < wake + schedule.gracePeriodMinutes {
            return .morning
        }

        if bed > wake {
            if mins >= bed || mins < wake { return .bedtime }
        } else {
            if mins >= bed && mins < wake { return .bedtime }
        }

        let today = cal.component(.weekday, from: date)
        for block in schedule.focusBlocks {
            guard block.activeDays.contains(today) else { continue }
            let start = block.startHour * 60 + block.startMinute
            let end   = block.endHour * 60 + block.endMinute
            let inBlock = start <= end
                ? (mins >= start && mins < end)
                : (mins >= start || mins < end)
            if inBlock {
                return .focus(blockName: block.name, endHour: block.endHour, endMinute: block.endMinute)
            }
        }

        return .free
    }

    // MARK: - Actions

    func confirmAwake() {
        hasConfirmedAwakeToday = true
    }

    func grantTemporaryUnlock() {
        temporaryUnlockEnd = Date.now.addingTimeInterval(Double(unlockDurationMinutes) * 60)
    }

    func resetDailyState() {
        hasConfirmedAwakeToday = false
        temporaryUnlockEnd = nil
    }
}

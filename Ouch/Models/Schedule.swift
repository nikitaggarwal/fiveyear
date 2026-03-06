import Foundation

struct Schedule: Codable, Equatable {
    var wakeUpHour: Int = 7
    var wakeUpMinute: Int = 0
    var bedtimeHour: Int = 23
    var bedtimeMinute: Int = 0
    var gracePeriodMinutes: Int = 10
    var focusBlocks: [FocusBlock] = []
    var activeDays: Set<Int> = [2, 3, 4, 5, 6] // 1=Sun … 7=Sat

    var wakeUpDate: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: wakeUpHour, minute: wakeUpMinute))
            ?? Date()
        }
        set {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            wakeUpHour = comps.hour ?? 7
            wakeUpMinute = comps.minute ?? 0
        }
    }

    var bedtimeDate: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: bedtimeHour, minute: bedtimeMinute))
            ?? Date()
        }
        set {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            bedtimeHour = comps.hour ?? 23
            bedtimeMinute = comps.minute ?? 0
        }
    }

    static func load() -> Schedule {
        guard let data = UserDefaults.shared.data(forKey: "schedule"),
              let schedule = try? JSONDecoder().decode(Schedule.self, from: data)
        else { return Schedule() }
        return schedule
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.shared.set(data, forKey: "schedule")
        }
    }
}

struct FocusBlock: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String = "Focus Time"
    var startHour: Int = 9
    var startMinute: Int = 0
    var endHour: Int = 12
    var endMinute: Int = 0
    var activeDays: Set<Int> = [2, 3, 4, 5, 6]

    var startDate: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: startHour, minute: startMinute))
            ?? Date()
        }
        set {
            let c = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            startHour = c.hour ?? 9
            startMinute = c.minute ?? 0
        }
    }

    var endDate: Date {
        get {
            Calendar.current.date(from: DateComponents(hour: endHour, minute: endMinute))
            ?? Date()
        }
        set {
            let c = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            endHour = c.hour ?? 12
            endMinute = c.minute ?? 0
        }
    }

    var formattedTimeRange: String {
        let start = formatTime(hour: startHour, minute: startMinute)
        let end = formatTime(hour: endHour, minute: endMinute)
        return "\(start) – \(end)"
    }

    private func formatTime(hour: Int, minute: Int) -> String {
        let h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
        let suffix = hour >= 12 ? "PM" : "AM"
        return "\(h):\(String(format: "%02d", minute)) \(suffix)"
    }
}

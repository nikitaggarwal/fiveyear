import UserNotifications

enum NotificationService {

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    static func scheduleMorningAlarm(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["morning_alarm"])

        let content = UNMutableNotificationContent()
        content.title = "Time to Wake Up"
        content.body = "Open Ouch to start your day. Social media is blocked until you confirm you're awake."
        content.sound = .defaultCritical

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morning_alarm", content: content, trigger: trigger)
        center.add(request)
    }

    static func scheduleBedtimeReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["bedtime_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Bedtime"
        content.body = "Social media is now blocked. Time to wind down."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "bedtime_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    static func scheduleBedRotWarning(hour: Int, minute: Int, graceMinutes: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["bedrot_warning"])

        let content = UNMutableNotificationContent()
        content.title = "Still in bed?"
        content.body = "Your grace period is almost up. Tap \"I'm Up\" or social media stays blocked."
        content.sound = .defaultCritical

        var dateComponents = DateComponents()
        let totalMinutes = hour * 60 + minute + graceMinutes - 2
        dateComponents.hour = totalMinutes / 60
        dateComponents.minute = totalMinutes % 60

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "bedrot_warning", content: content, trigger: trigger)
        center.add(request)
    }
}

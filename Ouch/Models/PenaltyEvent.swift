import Foundation
import SwiftData

@Model
final class PenaltyEvent {
    var timestamp: Date
    var context: String
    var amount: Double
    var unlockDurationMinutes: Int
    var venmoRecipient: String

    init(
        timestamp: Date = .now,
        context: String,
        amount: Double,
        unlockDurationMinutes: Int,
        venmoRecipient: String
    ) {
        self.timestamp = timestamp
        self.context = context
        self.amount = amount
        self.unlockDurationMinutes = unlockDurationMinutes
        self.venmoRecipient = venmoRecipient
    }
}

enum PenaltyContext: String, CaseIterable {
    case morning
    case focus
    case bedtime

    var displayName: String {
        switch self {
        case .morning: "Morning"
        case .focus: "Focus Time"
        case .bedtime: "Bedtime"
        }
    }

    var icon: String {
        switch self {
        case .morning: "sunrise.fill"
        case .focus: "lock.fill"
        case .bedtime: "moon.fill"
        }
    }
}

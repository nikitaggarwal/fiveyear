import Foundation

enum TimeState: Equatable {
    case morning
    case focus(blockName: String, endHour: Int, endMinute: Int)
    case bedtime
    case free

    var isBlocking: Bool {
        switch self {
        case .morning, .focus, .bedtime: true
        case .free: false
        }
    }

    var displayTitle: String {
        switch self {
        case .morning: "Good Morning"
        case .focus(let name, _, _): name
        case .bedtime: "Bedtime"
        case .free: "Free Time"
        }
    }
}

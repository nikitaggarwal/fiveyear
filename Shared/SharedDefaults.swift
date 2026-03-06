import Foundation

extension UserDefaults {
    nonisolated(unsafe) static let shared = UserDefaults(suiteName: "group.com.ouchapp.app") ?? .standard
}

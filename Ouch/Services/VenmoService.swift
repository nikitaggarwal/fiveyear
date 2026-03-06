import UIKit

@MainActor
enum VenmoService {
    static func pay(username: String, amount: Double, note: String) {
        let encodedNote = note.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? note
        let amountStr = String(format: "%.2f", amount)

        // Venmo deep link
        let venmoURL = "venmo://paycharge?txn=pay&recipients=\(username)&amount=\(amountStr)&note=\(encodedNote)"

        // Fallback to Venmo website
        let webURL = "https://venmo.com/\(username)?txn=pay&amount=\(amountStr)&note=\(encodedNote)"

        if let url = URL(string: venmoURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: webURL) {
            UIApplication.shared.open(url)
        }
    }
}

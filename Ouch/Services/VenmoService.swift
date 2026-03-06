import UIKit

@MainActor
enum VenmoService {
    static func pay(username: String, amount: Double, note: String) {
        let amountStr = String(format: "%.2f", amount)
        // Venmo's deep link converts normal spaces to "+".
        // Non-breaking spaces (U+00A0) display identically but avoid this.
        let fixedNote = note.replacingOccurrences(of: " ", with: "\u{00A0}")
        let encodedNote = fixedNote.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? note

        let venmoURL = "venmo://paycharge?txn=pay&recipients=\(username)&amount=\(amountStr)&note=\(encodedNote)"
        let webURL = "https://venmo.com/\(username)?txn=pay&amount=\(amountStr)&note=\(encodedNote)"

        if let url = URL(string: venmoURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: webURL) {
            UIApplication.shared.open(url)
        }
    }
}

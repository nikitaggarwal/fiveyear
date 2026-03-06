import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldActionExtension: ShieldActionDelegate {

    let store = ManagedSettingsStore()

    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            // User wants to pay to unlock — open the main app which handles Venmo flow
            // Temporarily remove the shield so the user can access the main app
            store.clearAllSettings()
            completionHandler(.defer)

        case .secondaryButtonPressed:
            completionHandler(.close)

        @unknown default:
            completionHandler(.close)
        }
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            store.clearAllSettings()
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            completionHandler(.close)
        }
    }
}

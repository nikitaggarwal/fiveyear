import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(red: 0.04, green: 0.04, blue: 0.07, alpha: 1.0),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(
                text: "Blocked by Ouch",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This app is blocked right now. Pay $5 to unlock for 5 minutes.",
                color: UIColor(white: 0.55, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Pay $5 to Unlock",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 1.0, green: 0.27, blue: 0.27, alpha: 1.0),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Close App",
                color: UIColor(white: 0.55, alpha: 1.0)
            )
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application)
    }

    override func configuration(
        shielding webDomain: WebDomain
    ) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(red: 0.04, green: 0.04, blue: 0.07, alpha: 1.0),
            title: ShieldConfiguration.Label(text: "Blocked by Ouch", color: .white),
            subtitle: ShieldConfiguration.Label(
                text: "This site is blocked.",
                color: UIColor(white: 0.55, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Pay $5 to Unlock", color: .white),
            primaryButtonBackgroundColor: UIColor(red: 1.0, green: 0.27, blue: 0.27, alpha: 1.0),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Go Back",
                color: UIColor(white: 0.55, alpha: 1.0)
            )
        )
    }
}

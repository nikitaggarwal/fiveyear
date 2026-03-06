import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {

    private let titles = [
        "nice try, bestie",
        "absolutely not",
        "this is an intervention",
        "nope nope nope",
        "not happening",
        "you again?",
        "be so for real",
        "girl put it down",
        "caught you",
        "wrong app buddy",
        "the audacity",
        "stay focused queen",
        "not on my watch",
        "you don't need this",
        "respectfully, no",
        "blocked and unbothered",
        "sir this is a focus zone",
        "you're better than this",
        "back away slowly",
        "we talked about this",
        "seriously?",
        "oh no you don't",
        "red card",
        "denied",
        "you shall not pass",
        "ahem",
        "how about no",
        "did you forget?",
        "willpower loading...",
        "distraction detected",
    ]

    private let subtitles = [
        "go drink some water or something",
        "this app misses you but your goals miss you more",
        "touch grass, not this app",
        "you'll survive without reels for a bit",
        "go stare at a wall it's more productive",
        "your screen time report is already embarrassing enough",
        "remember why you downloaded ouch in the first place",
        "the group chat will still be there later",
        "close your eyes and take a deep breath instead",
        "you were doing so well don't blow it now",
        "go do literally anything else",
        "the memes aren't going anywhere",
        "future you is watching and judging",
        "this is the part where you prove yourself",
        "your attention span called and it wants a refund",
        "you don't even enjoy scrolling you just do it",
        "go for a walk your legs still work",
        "imagine telling someone you paid $5 for instagram",
        "the explore page isn't that interesting be honest",
        "there's a book somewhere gathering dust for you",
        "you're one tap away from losing money",
        "your dopamine receptors are begging for a break",
        "plot twist: the scroll never ends",
        "you set this up because you knew you'd try this",
    ]

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let title = titles.randomElement() ?? titles[0]
        let subtitle = subtitles.randomElement() ?? subtitles[0]

        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(red: 0.04, green: 0.04, blue: 0.07, alpha: 1.0),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(
                text: title,
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: subtitle,
                color: UIColor(white: 0.55, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Pay to Unlock",
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
        let title = titles.randomElement() ?? titles[0]
        let subtitle = subtitles.randomElement() ?? subtitles[0]

        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: UIColor(red: 0.04, green: 0.04, blue: 0.07, alpha: 1.0),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(text: title, color: .white),
            subtitle: ShieldConfiguration.Label(
                text: subtitle,
                color: UIColor(white: 0.55, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Pay to Unlock", color: .white),
            primaryButtonBackgroundColor: UIColor(red: 1.0, green: 0.27, blue: 0.27, alpha: 1.0),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Go Back",
                color: UIColor(white: 0.55, alpha: 1.0)
            )
        )
    }
}

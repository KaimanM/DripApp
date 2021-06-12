import UIKit

class WhatsNewController {

    private let featureItems = [
        WhatsNewItem(title: "What's New?",
                    subtitle: """
                            On every update Drip will now show you What's New using this menu you're seeing right now!
                            """,
                    image: UIImage(systemName: "wand.and.stars")!
        ),
        WhatsNewItem(
            title: "Reminder Notifications",
            subtitle: "Drip now has the ability to send you helpful reminders throughout the day!",
            image: UIImage(systemName: "clock.arrow.circlepath")!
        ),
        WhatsNewItem(
            title: "Awards Update",
            subtitle: """
                Based on user feedback, Drip now shows the name of all awards to give you a hint on how to unlock them!
                """,
            image: UIImage(systemName: "crown")!
        )
    ]

    func showWhatsNewIfNeeded(view: UIViewController,
                              userDefaultsController: UserDefaultsControllerProtocol) {

        let lastSavedAppVersion = userDefaultsController.currentVersion
        let liveAppVersion = Bundle.main.appVersion

        // returns if live app version is the same or newer than lastCurrentAppVersion
        guard liveAppVersion.compare(lastSavedAppVersion, options: .numeric) == .orderedDescending else {
            return
        }

        userDefaultsController.currentVersion = liveAppVersion

        let whatsNewVC = WhatsNewScreenBuilder.init(featureItems: featureItems).build()

        view.present(whatsNewVC, animated: true)
    }

    func showWhatsNew(view: UIViewController) {
        let whatsNewVC = WhatsNewScreenBuilder.init(featureItems: featureItems).build()
        view.present(whatsNewVC, animated: true)
    }

}

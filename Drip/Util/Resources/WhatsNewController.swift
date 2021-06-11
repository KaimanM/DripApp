import UIKit

class WhatsNewController {

    private let featureItems = [
        WhatsNewItem(title: "What's New?",
                    subtitle: "This menu you can see right now, to help you let you know what's new!",
                    image: UIImage(systemName: "star")!
        ),
        WhatsNewItem(
            title: "Reminder Notifications",
            subtitle: "Drip now has the ability to send you helpful reminders throughout the day!",
            image: UIImage(systemName: "bubble.left")!
        ),
        WhatsNewItem(
            title: "Awards Update",
            subtitle: "Drip now shows the name of all awards and sorts the awards based on what you've unlocked!",
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

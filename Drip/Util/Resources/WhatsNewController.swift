import UIKit

class WhatsNewController {

    func showWhatsNewIfNeeded(view: UIViewController,
                              userDefaultsController: UserDefaultsControllerProtocol) {

        let lastCurrentAppVersion = userDefaultsController.currentVersion
        let liveAppVersion = Bundle.main.appVersion

        // returns if live app version is the same or newer than lastCurrentAppVersion
        guard liveAppVersion.compare(lastCurrentAppVersion, options: .numeric) == .orderedDescending else {
            return
        }

        userDefaultsController.currentVersion = liveAppVersion

        let featureItems = [
            WhatsNewItem(title: "What's New!",
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

        let whatsNewVC = WhatsNewScreenBuilder.init(featureItems: featureItems).build()

        view.present(whatsNewVC, animated: true)
    }

}

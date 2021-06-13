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

        // Returns when it's not a new Major or Minor release.
        guard isNewMajorMinor(lastSavedAppVer: lastSavedAppVersion, liveAppVer: liveAppVersion) == .newer else {
            return
        }

        // Updates Saved app version with new version
        userDefaultsController.currentVersion = liveAppVersion

        showWhatsNew(view: view)
    }

    private func isNewMajorMinor(lastSavedAppVer: String, liveAppVer: String) -> VersionCompareResult {
        let lastSavedComponents = lastSavedAppVer.components(separatedBy: ".")
        let liveAppComponents = liveAppVer.components(separatedBy: ".")

        guard lastSavedComponents.count == 3, liveAppComponents.count == 3 else { return .error }

        let lastMinor = "\(lastSavedComponents[0]).\(lastSavedComponents[1])"
        let liveMinor = "\(liveAppComponents[0]).\(liveAppComponents[1])"

        switch liveMinor.compare(lastMinor, options: .numeric) {
        case .orderedDescending:
            return .newer
        case .orderedAscending:
            return .older
        case .orderedSame:
            return .same
        }
    }

    func showWhatsNew(view: UIViewController) {
        let whatsNewVC = WhatsNewScreenBuilder(featureItems: featureItems).build()
        view.present(whatsNewVC, animated: true)
    }

    private enum VersionCompareResult {
        case newer, older, same, error
    }

}

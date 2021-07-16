import UIKit

class WhatsNewController {

    private let featureItems = [
        WhatsNewItem(title: "Health Kit Support!",
                    subtitle: """
                            You can now choose to sync your drink entrys with Apple's Health Kit, navigate to \
                            settings to enable this feature!
                            """,
                    image: UIImage(systemName: "heart.circle")!
        ),
        WhatsNewItem(
            title: "Improved Volume Selection",
            subtitle: """
                    You can now input drink volumes with a precision of 5ml. Tap the \u{00B1} button on the drink \
                    volume selection to go into precision mode!
                    """,
            image: UIImage(systemName: "plusminus")!
        ),
        WhatsNewItem(
            title: "Annoying Bug Fixes",
            subtitle: """
                    Drink coefficients were causing some issues for users when deleting old drinks causing daily \
                    totals to be lower than zero! Coeffiecients have been changed under the hood to fix this issue!
                    Hooray!
                    """,
            image: UIImage(systemName: "ladybug")!
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

import Foundation

final class SettingsPresenter: SettingsPresenterProtocol {
    weak private(set) var view: SettingsViewProtocol?

    let cellDataSection1: [SettingsCellData] = [
        SettingsCellData(title: "Name", imageName: "square.and.pencil", backgroundColour: .systemBlue),
        SettingsCellData(title: "Goal", imageName: "slider.horizontal.3", backgroundColour: .systemIndigo),
        SettingsCellData(title: "Favourites", imageName: "star", backgroundColour: .systemRed),
        SettingsCellData(title: "Drink Coefficients", imageName: "info.circle", backgroundColour: .systemTeal),
        SettingsCellData(title: "Notifications", imageName: "bell", backgroundColour: .systemGreen),
        SettingsCellData(title: "HealthKit", imageName: "heart.circle", backgroundColour: .magenta)

    ]

    let cellDataSection2: [SettingsCellData] = [
        SettingsCellData(title: "About", imageName: "at", backgroundColour: .systemBlue),
        SettingsCellData(title: "What's New", imageName: "wand.and.stars", backgroundColour: .magenta),
        SettingsCellData(title: "Thanks to", imageName: "gift", backgroundColour: .systemIndigo),
        SettingsCellData(title: "Privacy Policy", imageName: "hand.raised", backgroundColour: .systemGreen),
        SettingsCellData(title: "Rate Drip", imageName: "heart.fill", backgroundColour: .systemRed)
    ]

    init(view: SettingsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Settings")
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return cellDataSection1.count
        case 1:
            return cellDataSection2.count
        default:
            return 0
        }
    }

    func getCellDataForIndexPath(indexPath: IndexPath) -> SettingsCellData {
        switch indexPath.section {
        case 0:
            return cellDataSection1[indexPath.row]
        case 1:
            return cellDataSection2[indexPath.row]
        default:
            return cellDataSection1[0]
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func didSelectRowAt(indexPath: IndexPath) {
        guard let userDefaultsController = view?.userDefaultsController,
              let healthKitController = view?.healthKitController else { return }
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            view?.changeNameTapped()
        case (0, 1):
            view?.pushView(SettingsDetailScreenBuilder(type: .goal,
                                                       userDefaultsController: userDefaultsController,
                                                       healthKitController: healthKitController).build())
        case (0, 2):
            view?.pushView(SettingsDetailScreenBuilder(type: .favourite,
                                                 userDefaultsController: userDefaultsController,
                                                 healthKitController: healthKitController).build())
        case (0, 3):
            view?.pushView(SettingsDetailScreenBuilder(type: .coefficient,
                                                 userDefaultsController: userDefaultsController,
                                                 healthKitController: healthKitController).build())
        case (0, 4):
            view?.pushView(NotificationsScreenBuilder(userDefaultsController: userDefaultsController).build())
        case (0, 5):
            view?.pushView(SettingsDetailScreenBuilder(type: .healthKit,
                                                 userDefaultsController: userDefaultsController,
                                                 healthKitController: healthKitController).build())
        case (1, 0):
            view?.pushView(SettingsDetailScreenBuilder(type: .about,
                                                 userDefaultsController: userDefaultsController,
                                                 healthKitController: healthKitController).build())
        case (1, 1):
            view?.showWhatsNew()
        case (1, 2):
            view?.pushView(SettingsDetailScreenBuilder(type: .attribution,
                                                 userDefaultsController: userDefaultsController,
                                                 healthKitController: healthKitController).build())
        case (1, 3):
            let privacyPolicyURL = URL(string: "https://dripmobile.app/privacy.html")!
            view?.showSafariWith(url: privacyPolicyURL)
        case (1, 4):
            view?.showReviewPrompt()
        default:
            break
        }
    }

    func fetchName() -> String {
        guard let userDefaultsController = view?.userDefaultsController else { return "Buddy" }
        return userDefaultsController.name
    }

    func updateName(name: String?) {
        guard let userDefaultsController = view?.userDefaultsController else { return }
        if let name = name, !name.isEmpty, name.count <= 15 {
            userDefaultsController.name = name
        } else {
            view?.invalidName()
        }
    }

}

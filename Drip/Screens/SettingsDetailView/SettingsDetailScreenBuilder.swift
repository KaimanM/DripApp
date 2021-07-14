import UIKit

final class SettingsDetailScreenBuilder: ScreenBuilder {

    let type: SettingsType
    let userDefaultsController: UserDefaultsControllerProtocol
    let healthKitController: HealthKitControllerProtocol

    init(type: SettingsType, userDefaultsController: UserDefaultsControllerProtocol,
         healthKitController: HealthKitControllerProtocol) {
        self.type = type
        self.userDefaultsController = userDefaultsController
        self.healthKitController = healthKitController
    }

    func build() -> SettingsDetailView {
        let view = SettingsDetailView()
        view.settingsType = type
        view.userDefaultsController = userDefaultsController
        view.healthKitController = healthKitController
        view.presenter = SettingsDetailPresenter(view: view)

        return view
    }
}

enum SettingsType {
    case goal
    case favourite
    case coefficient
    case attribution
    case about
    case healthKit
}

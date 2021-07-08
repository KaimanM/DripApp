import UIKit

final class SettingsDetailScreenBuilder: ScreenBuilder {

    let type: SettingsType
    let userDefaultsController: UserDefaultsControllerProtocol

    init(type: SettingsType, userDefaultsController: UserDefaultsControllerProtocol) {
        self.type = type
        self.userDefaultsController = userDefaultsController
    }

    func build() -> SettingsDetailView {
        let view = SettingsDetailView()
        view.settingsType = type
        view.userDefaultsController = userDefaultsController
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

import UIKit

final class NotificationsScreenBuilder: ScreenBuilder {

    let userDefaultsController: UserDefaultsControllerProtocol

    init(userDefaultsController: UserDefaultsControllerProtocol) {
        self.userDefaultsController = userDefaultsController
    }

    func build() -> NotificationsView {
        let view = NotificationsView()
        view.presenter = NotificationsPresenter(view: view)
        view.userDefaultsController = userDefaultsController
        return view
    }
}

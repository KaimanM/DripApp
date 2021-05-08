import UIKit

final class NotificationsScreenBuilder: ScreenBuilder {

    func build() -> NotificationsView {
        let view = NotificationsView()
        view.presenter = NotificationsPresenter(view: view)

        view.presenter = NotificationsPresenter(view: view)

        return view
    }
}

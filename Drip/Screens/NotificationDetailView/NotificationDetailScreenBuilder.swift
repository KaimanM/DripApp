import UIKit

final class NotificationDetailScreenBuilder: ScreenBuilder {

    let notification: Notification

    init(notification: Notification) {
        self.notification = notification
    }

    func build() -> NotificationDetailView {
        let view = NotificationDetailView()
        view.presenter = NotificationDetailPresenter(view: view)
        view.notification = notification
        return view
    }
}

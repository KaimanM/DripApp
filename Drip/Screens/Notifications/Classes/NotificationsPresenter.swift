import Foundation
import UserNotifications

class NotificationsPresenter: NotificationsPresenterProtocol {
    var view: NotificationsViewProtocol?
    
    let notificationController = LocalNotificationController()
    var pendingNotifCount = 0

    init(view: NotificationsViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
    }

    func onViewDidAppear() {
        scheduledNotificationsCount(completion: {
            DispatchQueue.main.async {
                self.view!.reloadTableView()
            }
        })
    }

    // MARK: - Notifications -

    func notificationTimeStampForRow(row: Int, completion: @escaping (String) -> Void) {
        notificationController.listScheduledNotifications(completionHandler: { notifications in
            guard let trigger = notifications[row].trigger as? UNCalendarNotificationTrigger,
                  let date = trigger.dateComponents.date else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            completion(dateFormatter.string(from: date))
        })
    }

    func scheduledNotificationsCount(completion: @escaping () -> Void) {
        notificationController.listScheduledNotifications(completionHandler: { notifications in
            self.pendingNotifCount = notifications.count
            completion()
        })
    }

    func numberOfRowsInSection() -> Int {
        return pendingNotifCount
    }
}

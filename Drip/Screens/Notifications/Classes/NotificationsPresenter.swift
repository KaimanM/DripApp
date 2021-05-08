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
        view?.updateTitle(title: "Notifications")
        let headingText = "Daily Reminders"
        let bodyText = """
            Use this settings page to configure setting up daily reminder notifications.

            We've set you up with three notifications but feel free to customise them to your needs!
            """
        view?.setupNotificationsView(headingText: headingText, bodyText: bodyText)
    }

    func onViewDidAppear() {
        fetchNotifsAndReload()
    }

    // MARK: - Notifications -

    func fetchNotifsAndReload() {
        scheduledNotificationsCount(completion: {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        })
    }

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

    func setReminderCount(to reminderCount: Int) {
        notificationController.notifications.removeAll()
        if pendingNotifCount > reminderCount {
            for idToRemove in reminderCount+1...pendingNotifCount {
                print("removing id \(idToRemove)")
                notificationController.removePendingNotificationWithId(id: idToRemove)
            }
//            pendingNotifCount = reminderCount
        } else if reminderCount > pendingNotifCount {
            for idToAdd in pendingNotifCount+1...reminderCount {
                notificationController.notifications.append(Notification(id: "\(idToAdd)", title: "Let's stay hydrated!",
                                                                         body: "This is your daily reminder to keep at it!",
                                                                         timeStamp: DateComponents(calendar: Calendar.current,
                                                                                                   hour: 00, minute: 01)))
            }
            notificationController.schedule()
        }
//        pendingNotifCount = reminderCount
        scheduledNotificationsCount(completion: {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        })

    }

    func numberOfRowsInSection() -> Int {
        return pendingNotifCount
    }
}

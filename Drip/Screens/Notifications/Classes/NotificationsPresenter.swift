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

    func onViewWillAppear() {
        fetchNotifications()
    }

    func onViewWillDisappear() {
        notificationController.schedule()
    }

    // MARK: - Notifications -

    func fetchNotifications() {
        notificationController.fetchPendingNotifications {
            DispatchQueue.main.async {
                let notifCount = self.notificationController.notifications.count
                self.view?.updateReminderCountTitle(count: notifCount)
                self.view?.reloadTableView()
                let pickerRow = notifCount == 0 ? 0 : notifCount-1
                self.view?.setPickerRow(row: pickerRow)
            }
        }
    }

    func timeStampForRow(row: Int) -> String {
        guard let timeStamp = notificationController.notifications[row].timeStamp.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: timeStamp)
    }

    func setReminderCount(to reminderCount: Int) {
        let pending = notificationController.notifications.count
        if pending > reminderCount {
            for idToRemove in reminderCount+1...pending {
                print("removing id \(idToRemove)")
                notificationController.removePendingNotificationWithId(id: idToRemove)
            }
        } else if reminderCount > pending {
            for idToAdd in pending+1...reminderCount {
                notificationController.notifications.append(
                    Notification(id: "\(idToAdd)", title: "Let's stay hydrated!",
                                 body: "This is your daily reminder to keep at it!",
                                 timeStamp: DateComponents(calendar: Calendar.current,
                                                           hour: 00, minute: 01)))
            }
        }
        view?.reloadTableView()
    }

    func amendReminder(id: Int, timeStamp: Date) {
        notificationController.removePendingNotificationWithId(id: id)
        notificationController.notifications.removeAll(where: { notification in
            notification.id == "\(id)"
        })
        let hour = Calendar.current.component(.hour, from: timeStamp)
        let minute = Calendar.current.component(.minute, from: timeStamp)
        notificationController.notifications.append(
            Notification(id: "\(id)", title: "Let's stay hydrated!",
                         body: "This is your daily reminder to keep at it!",
                         timeStamp: DateComponents(calendar: Calendar.current,
                                                   hour: hour, minute: minute)))
    }

    func disableNotifications() {
        notificationController.removeAllPendingNotifications()
        view?.reloadTableView()
    }

    func enableNotifications() {
        notificationController.notifications = [
            Notification(id: "\(1)", title: "Let's stay hydrated!",
                         body: "This is your daily reminder to keep at it!",
                         timeStamp: DateComponents(calendar: Calendar.current,
                                                   hour: 09, minute: 00)),
            Notification(id: "\(2)", title: "Let's stay hydrated!",
                         body: "This is your daily reminder to keep at it!",
                         timeStamp: DateComponents(calendar: Calendar.current,
                                                   hour: 15, minute: 00)),
            Notification(id: "\(3)", title: "Let's stay hydrated!",
                         body: "This is your daily reminder to keep at it!",
                         timeStamp: DateComponents(calendar: Calendar.current,
                                                   hour: 21, minute: 00))]
        view?.reloadTableView()
    }

    func numberOfRowsInSection() -> Int {
        return notificationController.notifications.count
    }
}

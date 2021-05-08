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
        fetchNotifsAndReload()
    }

//    func onViewWillAppear() {
//
//    }

    func onViewWillDisappear() {
        notificationController.schedule(completion: {
//            self.fetchNotifsAndReload()
        })
    }

    // MARK: - Notifications -

    func fetchNotifsAndReload() {
        scheduledNotificationsCount(completion: {
            DispatchQueue.main.async {
                self.view?.updateReminderCountTitle(count: self.pendingNotifCount)
                self.view?.reloadTableView()
                let pickerRow = self.pendingNotifCount == 0 ? 0 : self.pendingNotifCount-1
                self.view?.setPickerRow(row: pickerRow)
            }
        })
    }

    func notificationTimeStampForRow(row: Int, completion: @escaping (Date) -> Void) {
        notificationController.listScheduledNotifications(completionHandler: { notifications in
            guard let request = notifications.filter({$0.identifier == "\(row+1)"}).first,
                  let trigger = request.trigger as? UNCalendarNotificationTrigger,
                  let date = trigger.dateComponents.date else { return }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm a"
            completion(date)

//            let correctedObject = notifications.map({ $0.identifier })
//            let request = notifications.filter({$0.identifier == "\(row+1)"})
        })
    }

    func scheduledNotificationsCount(completion: @escaping () -> Void) {
        notificationController.listScheduledNotifications(completionHandler: { notifications in
            self.pendingNotifCount = notifications.count
            completion()
        })
    }

    func setReminderCount(to reminderCount: Int) {
//        notificationController.notifications.removeAll()
        if pendingNotifCount > reminderCount {
            for idToRemove in reminderCount+1...pendingNotifCount {
                print("removing id \(idToRemove)")
                notificationController.removePendingNotificationWithId(id: idToRemove)
            }
            fetchNotifsAndReload()
        } else if reminderCount > pendingNotifCount {
            for idToAdd in pendingNotifCount+1...reminderCount {
                notificationController.notifications.append(
                    Notification(id: "\(idToAdd)", title: "Let's stay hydrated!",
                                 body: "This is your daily reminder to keep at it!",
                                 timeStamp: DateComponents(calendar: Calendar.current,
                                                           hour: 00, minute: 01)))
            }
            notificationController.schedule(completion: {
                self.fetchNotifsAndReload()
            })
        }
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
        notificationController.notifications.removeAll()
        notificationController.removeAllPendingNotifications()
        fetchNotifsAndReload()
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
        notificationController.schedule(completion: {
            self.fetchNotifsAndReload()
        })
    }

    func numberOfRowsInSection() -> Int {
        return pendingNotifCount
    }
}

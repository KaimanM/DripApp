import Foundation
import UserNotifications

class NotificationsPresenter: NotificationsPresenterProtocol {
    var view: NotificationsViewProtocol?

//    let notificationController = LocalNotificationController()
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
        checkNotificationStatus()
    }

    func onViewWillDisappear() {
        view?.notificationController.checkAuthStatus(completion: { status in
            if status == .authorized || status == .provisional {
                self.view?.notificationController.schedule(completion: nil)
            }
        })
    }

    // MARK: - Notifications -

    func checkNotificationStatus() {
        view?.notificationController.checkAuthStatus(completion: { status in
                switch status {
                case .authorized, .provisional:
                    switch self.view?.userDefaultsController.enabledNotifications {
                    case true:
                        self.fetchNotifications()
                        self.view?.setToggleStatus(isOn: true)
                    case false:
                        self.view?.setToggleStatus(isOn: false)
                    default:
                        self.view?.setToggleStatus(isOn: false)
                    }
                default:
                    self.view?.setToggleStatus(isOn: false)
                    self.view?.userDefaultsController.enabledNotifications = false
                }
        })
    }

    func onSwitchToggle(isOn: Bool) {
        switch isOn {
        case true:
            view?.notificationController.checkAuthStatus(completion: { status in
                    switch status {
                    case .authorized, .provisional:
                        self.enableNotifications()
                        self.view?.setToggleStatus(isOn: true)
                        self.view?.resetPicker()
                        self.view?.userDefaultsController.enabledNotifications = true
                    case .notDetermined:
                        self.view?.notificationController.requestAuth(completion: { granted in
                            switch granted {
                            case true:
                                self.enableNotifications()
                                self.view?.setToggleStatus(isOn: true)
                                self.view?.resetPicker()
                                self.view?.userDefaultsController.enabledNotifications = true
                            case false:
                                self.view?.showSettingsNotificationDialogue()
                                self.view?.setToggleStatus(isOn: false)
                                self.view?.userDefaultsController.enabledNotifications = false
                            }
                        })
                    default:
                        self.view?.showSettingsNotificationDialogue()
                        self.view?.setToggleStatus(isOn: false)
                        self.view?.userDefaultsController.enabledNotifications = false
                    }
            })
        case false:
            disableNotifications()
            view?.setToggleStatus(isOn: false)
            self.view?.userDefaultsController.enabledNotifications = false
        }
    }

    func fetchNotifications() {
        view?.notificationController.fetchPendingNotifications {
                if let notifCount = self.view?.notificationController.notifications.count {
                    self.view?.updateReminderCountTitle(count: notifCount)
                    self.view?.reloadTableView()
                    let pickerRow = notifCount == 0 ? 0 : notifCount-1
                    self.view?.setPickerRow(row: pickerRow)
                }
        }
    }

    func timeStampForRow(row: Int) -> String {
        guard let notifications = view?.notificationController.notifications,
              row >= 0 && row < notifications.count,
              let timeStamp = notifications[row].timeStamp.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: timeStamp)
    }

    func setReminderCount(to reminderCount: Int) {
        guard let pending = view?.notificationController.notifications.count else { return }
        if pending > reminderCount {
            for idToRemove in reminderCount+1...pending {
                print("removing id \(idToRemove)")
                view?.notificationController.removePendingNotificationWithId(id: idToRemove)
            }
        } else if reminderCount > pending {
            for idToAdd in pending+1...reminderCount {
                view?.notificationController.notifications.append(
                    Notification(id: "\(idToAdd)", title: "Let's stay hydrated!",
                                 body: "Let's have a drink!",
                                 timeStamp: DateComponents(calendar: Calendar.current,
                                                           hour: 00, minute: 01),
                                 sound: true))
            }
        }
        view?.reloadTableView()
    }

    func amendReminder(notification: Notification) {
        if let id = Int(notification.id),
           let notifIndex = view?.notificationController.notifications.firstIndex(where: {$0.id == "\(id)"}) {
            view?.notificationController.notifications[notifIndex] = notification
        }
        view?.reloadTableView()
    }

    func disableNotifications() {
        view?.notificationController.removeAllPendingNotifications()
        view?.reloadTableView()
    }

    func enableNotifications() {
        view?.notificationController.setupDefaultNotifications()
        view?.reloadTableView()
    }

    // MARK: - Table View -

    func numberOfRowsInSection() -> Int {
        return view?.notificationController.notifications.count ?? 0
    }

    func getNotificationInfoForRow(row: Int) -> Notification {
        guard let notifications = view?.notificationController.notifications,
              row >= 0 && row < notifications.count
        else {
            return Notification(id: "-1",
                                title: "Error",
                                body: "Error",
                                timeStamp: DateComponents(calendar: Calendar.current,
                                                          hour: 00, minute: 00),
                                sound: false)
        }
        return notifications[row]
    }
}

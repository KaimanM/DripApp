import Foundation
import UserNotifications

class LocalNotificationController {

    var notifications = [Notification]()

    let center = UNUserNotificationCenter.current()

    func listScheduledNotifications(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        center.getPendingNotificationRequests(completionHandler: { notifications in
//            for notification in notifications {
//                print(notification)
//            }
            completionHandler(notifications)
        })
    }

    func fetchPendingNotifications(completion: @escaping () -> Void) {
        center.getPendingNotificationRequests(completionHandler: { notifications in
            for notification in notifications {
                if let trigger = notification.trigger as? UNCalendarNotificationTrigger {
                    self.notifications.append(Notification(id: notification.identifier,
                                                           title: notification.content.title,
                                                           body: notification.content.body,
                                                           timeStamp: trigger.dateComponents))
                }
            }
            completion()
        })
    }

    private func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge],
                                                                completionHandler: { granted, error in
            if granted && error == nil {
                self.scheduleNotifications()
            }
        })
    }

    func schedule(completion: (() -> Void)? = nil) {
        center.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorisation()
            case .authorized, .provisional:
                self.scheduleNotifications(completion: completion)
            default:
                break
            }
        })
    }

    func scheduleNotifications(completion: (() -> Void)? = nil) {

        let operationQueue = OperationQueue()

        let operation1 = BlockOperation {

            let group = DispatchGroup()

            for notification in self.notifications {
                group.enter()
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body
                content.sound = .default

                let trigger = UNCalendarNotificationTrigger(dateMatching: notification.timeStamp, repeats: true)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let request = UNNotificationRequest(identifier: notification.id,
                                                    content: content,
                                                    trigger: trigger)
                self.center.add(request, withCompletionHandler: { error in
                    group.leave()
                    guard error == nil else { return }
                    print("Notification scheduled! ID = \(notification.id)")
                })
            }

            group.wait()
        }

        let operation2 = BlockOperation {
            print("finito")
            if let completion = completion { completion() }
        }

        operation2.addDependency(operation1)

        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)

    }

    func removeAllPendingNotifications() {
        notifications.removeAll()
        center.removeAllPendingNotificationRequests()
    }

    func removePendingNotificationWithId(id: Int) {
        notifications.removeAll(where: { $0.id == "\(id)" })
        center.removePendingNotificationRequests(withIdentifiers: ["\(id)"])
    }

}

struct Notification {
    var id: String
    var title: String
    var body: String
    var timeStamp: DateComponents
}

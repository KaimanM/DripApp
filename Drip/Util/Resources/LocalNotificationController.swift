import Foundation
import UserNotifications

class LocalNotificationController {

    var notifications = [Notification]()

    let center = UNUserNotificationCenter.current()

    func fetchPendingNotifications(completion: @escaping () -> Void) {
        center.getPendingNotificationRequests(completionHandler: { notifications in
            for notification in notifications {
                if let trigger = notification.trigger as? UNCalendarNotificationTrigger,
                   let sound = notification.content.sound == nil ? false : true {
                    self.notifications.append(Notification(id: notification.identifier,
                                                           title: notification.content.title,
                                                           body: notification.content.body,
                                                           timeStamp: trigger.dateComponents,
                                                           sound: sound))
                }
            }
            completion()
        })
    }

    private func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge, .sound],
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

        let scheduleOperation = BlockOperation {

            let group = DispatchGroup()

            for notification in self.notifications {
                group.enter()
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body

                let sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "droplet.mp3"))
                content.sound = notification.sound ? sound : .none

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

        let completionOperation = BlockOperation {
            print("finito")
            if let completion = completion { completion() }
        }

        completionOperation.addDependency(scheduleOperation)

        operationQueue.addOperation(scheduleOperation)
        operationQueue.addOperation(completionOperation)

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
    var sound: Bool
}

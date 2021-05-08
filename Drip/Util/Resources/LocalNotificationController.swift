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

    private func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge],
                                                                completionHandler: { granted, error in
            if granted && error == nil {
                self.scheduleNotifications()
            }
        })
    }

    func schedule() {
        center.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorisation()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        })
    }

    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.timeStamp, repeats: true)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: { error in
                guard error == nil else { return }
                print("Notification scheduled! ID = \(notification.id)")
            })
        }
    }

}

struct Notification {
    var id: String
    var title: String
    var body: String
    var timeStamp: DateComponents
}

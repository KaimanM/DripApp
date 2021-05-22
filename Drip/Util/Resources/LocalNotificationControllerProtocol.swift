import Foundation
import UserNotifications

protocol LocalNotificationControllerProtocol: AnyObject {
    var notifications: [Notification] { get set }
    func fetchPendingNotifications(completion: @escaping () -> Void)
    func requestAuth(completion: @escaping (_ :Bool) -> Void)
    func checkAuthStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
    func schedule(completion: (() -> Void)?)
    func removeAllPendingNotifications()
    func removePendingNotificationWithId(id: Int)
    func setupDefaultNotifications()
}

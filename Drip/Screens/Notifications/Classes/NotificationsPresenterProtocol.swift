import Foundation

protocol NotificationsPresenterProtocol: AnyObject {
    var view: NotificationsViewProtocol? { get }
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func numberOfRowsInSection() -> Int
    func getNotificationInfoForRow(row: Int) -> Notification
    func timeStampForRow(row: Int) -> String
    func setReminderCount(to reminderCount: Int)
    func amendReminder(notification: Notification)
    func disableNotifications()
    func enableNotifications()
    func onSwitchToggle(isOn: Bool)
}

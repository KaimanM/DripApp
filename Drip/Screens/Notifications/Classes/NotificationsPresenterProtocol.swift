import Foundation

protocol NotificationsPresenterProtocol: AnyObject {
    var view: NotificationsViewProtocol? { get }
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()

    func numberOfRowsInSection() -> Int
    func notificationTimeStampForRow(row: Int, completion: @escaping (String) -> Void)
    func scheduledNotificationsCount(completion: @escaping () -> Void)
    func setReminderCount(to reminderCount: Int)
    func amendReminder(id: Int, timeStamp: Date)
    func disableNotifications()
    func enableNotifications()
}

import Foundation

protocol NotificationsPresenterProtocol: class {
    var view: NotificationsViewProtocol? { get }
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()

    func numberOfRowsInSection() -> Int
    func notificationTimeStampForRow(row: Int, completion: @escaping (Date) -> Void)
    func scheduledNotificationsCount(completion: @escaping () -> Void)
    func setReminderCount(to reminderCount: Int)
    func amendReminder(id: Int, timeStamp: Date)
    func disableNotifications()
    func enableNotifications()
}

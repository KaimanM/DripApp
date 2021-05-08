import Foundation

protocol NotificationsPresenterProtocol: class {
    var view: NotificationsViewProtocol? { get }
    func onViewDidLoad()
    func onViewDidAppear()

    func numberOfRowsInSection() -> Int
    func notificationTimeStampForRow(row: Int, completion: @escaping (String) -> Void)
    func scheduledNotificationsCount(completion: @escaping () -> Void)
}

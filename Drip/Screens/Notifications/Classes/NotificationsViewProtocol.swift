import UIKit

protocol NotificationsViewProtocol: AnyObject {
    var presenter: NotificationsPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
    var notificationController: LocalNotificationControllerProtocol! { get set }

    func updateTitle(title: String)
    func presentView(_ view: UIViewController)

    func updateReminderCountTitle(count: Int)
    func setupNotificationsView(headingText: String, bodyText: String)
    func setPickerRow(row: Int)
    func reloadTableView()
    func setToggleStatus(isOn: Bool)
    func showSettingsNotificationDialogue()
    func resetPicker()
}

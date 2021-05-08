import UIKit

protocol NotificationsViewProtocol: class {
    var presenter: NotificationsPresenterProtocol! { get set }
    func updateTitle(title: String)

    func updateReminderCountTitle(count: Int)
    func setupNotificationsView(headingText: String, bodyText: String)
    func setPickerRow(row: Int)
    func reloadTableView()
}

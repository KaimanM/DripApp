import UIKit

protocol NotificationsViewProtocol: class {
    var presenter: NotificationsPresenterProtocol! { get set }
    func updateTitle(title: String)

    func setupNotificationsView(headingText: String, bodyText: String)
    func reloadTableView()
}

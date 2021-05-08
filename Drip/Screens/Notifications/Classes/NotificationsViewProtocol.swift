import UIKit

protocol NotificationsViewProtocol: class {
    var presenter: NotificationsPresenterProtocol! { get set }
    func updateTitle(title: String)

    func reloadTableView()
}

import UIKit

protocol NotificationDetailViewProtocol: AnyObject {
    var presenter: NotificationDetailPresenterProtocol! { get set }
    var notification: Notification! { get set }
    func updateTitle(title: String)
}

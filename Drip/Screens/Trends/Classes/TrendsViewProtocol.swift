import UIKit

protocol TrendsViewProtocol: AnyObject {
    var presenter: TrendsPresenterProtocol! { get set }
    var coreDataController: CoreDataControllerProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func reloadData()
}

import UIKit

protocol AwardsViewProtocol: AnyObject {
    var presenter: AwardsPresenterProtocol! { get set }
    var coreDataController: CoreDataControllerProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func pushView(_ view: UIViewController)
    func updateTitle(title: String)
    func reloadData()
}

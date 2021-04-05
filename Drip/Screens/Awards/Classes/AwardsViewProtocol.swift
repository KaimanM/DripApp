import UIKit

protocol AwardsViewProtocol: class {
    var presenter: AwardsPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func pushView(_ view: UIViewController)
    func updateTitle(title: String)
}

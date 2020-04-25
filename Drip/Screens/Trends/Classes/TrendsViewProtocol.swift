import UIKit

protocol TrendsViewProtocol: class {
    var presenter: TrendsPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
}

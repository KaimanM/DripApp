import UIKit

protocol AboutViewProtocol: class {
    var presenter: AboutPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
}

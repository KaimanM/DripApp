import UIKit

protocol TabBarViewProtocol: class {
    var presenter: TabBarPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func updateTitle(title: String?)
    func select(tab: TabBarElement)
}

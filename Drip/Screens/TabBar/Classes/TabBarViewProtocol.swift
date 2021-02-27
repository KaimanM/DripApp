import UIKit

protocol TabBarViewProtocol: class {
    var presenter: TabBarPresenterProtocol! { get set }
    var vcs: [UIViewController] { get set }

    func presentView(_ view: UIViewController)
    func updateTitle(title: String?)
}

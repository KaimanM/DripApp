import UIKit

protocol SettingsViewProtocol: class {
    var presenter: SettingsPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
}

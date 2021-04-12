import UIKit

protocol SettingsViewProtocol: class {
    var presenter: SettingsPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func pushView(_ view: UIViewController)

    func changeNameTapped()
    func invalidName()
}

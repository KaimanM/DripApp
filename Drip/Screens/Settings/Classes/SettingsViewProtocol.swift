import UIKit

protocol SettingsViewProtocol: AnyObject {
    var presenter: SettingsPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func pushView(_ view: UIViewController)
    func showReviewPrompt()

    func changeNameTapped()
    func invalidName()
    func showSafariWith(url: URL)
}

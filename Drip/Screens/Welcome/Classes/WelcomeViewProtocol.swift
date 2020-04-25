import UIKit

protocol WelcomeViewProtocol: class {
    
    var presenter: WelcomePresenterProtocol!  { get set }
    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
}


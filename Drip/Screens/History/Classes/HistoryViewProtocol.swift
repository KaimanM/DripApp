import UIKit

protocol HistoryViewProtocol: class {
    var presenter: HistoryPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
}

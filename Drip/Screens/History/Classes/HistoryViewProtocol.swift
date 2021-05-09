import UIKit

protocol HistoryViewProtocol: AnyObject {
    var presenter: HistoryPresenterProtocol! { get set }
    var coreDataController: CoreDataControllerProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
    func updateRingView(progress: CGFloat, date: Date, total: Double, goal: Double)

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func updateEditButton(title: String)

    func setupCalendar()
    func setupInfoPanel()
    func refreshUI()
}

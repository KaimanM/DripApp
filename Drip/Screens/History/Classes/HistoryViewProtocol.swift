import UIKit

protocol HistoryViewProtocol: class {
    var presenter: HistoryPresenterProtocol! { get set }
    var coreDataController: CoreDataControllerProtocol! { get set }
    func updateRingView(progress: CGFloat, date: Date, total: Double, goal: Double)

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func updateEditButton(title: String)

    func setupCalendar()
    func setupInfoPanel()
    func refreshUI()
}

import UIKit

protocol HistoryViewProtocol: class {
    var presenter: HistoryPresenterProtocol! { get set }
    var dataModel: DataModel? { get set }
    func updateRingView(progress: CGFloat, date: Date, total: Double, goal: Double)

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)

    func setupCalendar()
    func setupInfoPanel()
}

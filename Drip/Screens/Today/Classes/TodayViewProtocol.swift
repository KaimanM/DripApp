import UIKit

protocol TodayViewProtocol: class {
    var presenter: TodayPresenterProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat)
    func setRingProgress(progress: Double)
}

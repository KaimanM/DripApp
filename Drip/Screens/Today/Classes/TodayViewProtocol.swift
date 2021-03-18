import UIKit

protocol TodayViewProtocol: class {
    var presenter: TodayPresenterProtocol! { get set }
    var coreDataController: CoreDataControllerProtocol! { get set }

    func presentView(_ view: UIViewController)
    func showView(_ view: UIViewController)
    func updateTitle(title: String)
    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat)
    func setRingProgress(progress: Double)
    func updateButtonImages(image1Name: String, image2Name: String, image3Name: String, image4Name: String)
    func animateLabel(endValue: Double, animationDuration: Double)
    func updateButtonSubtitles(subtitle1: String, subtitle2: String, subtitle3: String, subtitle4: String)
    func setupGradientBars(dailyGoal: Int, morningGoal: Int, afternoonGoal: Int, eveningGoal: Int)
    func setTodayGradientBarProgress(total: Double, goal: Double)
    func setMorningGradientBarProgress(total: Double, goal: Double)
    func setAfternoonGradientBarProgress(total: Double, goal: Double)
    func setEveningGradientBarProgress(total: Double, goal: Double)
    func setButtonTitles(remainingText: String, goalText: String)
}

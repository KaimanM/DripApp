import UIKit

protocol SettingsDetailViewProtocol: AnyObject {
    var presenter: SettingsDetailPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
    var healthKitController: HealthKitControllerProtocol! { get set }
    var settingsType: SettingsType! { get set }

    func updateTitle(title: String)
    func setupGoalView(currentGoal: Double, headingText: String, bodyText: String)
    func setupFavouritesView(headingText: String, bodyText: String)
    func setupCoefficientView(headingText: String, bodyText: String)
    func setupHealthKitView(headingText: String, bodyText: String)
    func setupAttributionView(headingText: String, bodyText: String)
    func setupAboutView(headingText: String, bodyText: String)
    func showAlertController(title: String, message: String)
    func showHealthKitDialogue()
    func popView()
    func reloadCollectionView()
    func setToggleStatus(isOn: Bool)
}

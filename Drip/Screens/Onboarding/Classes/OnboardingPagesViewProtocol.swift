import UIKit

protocol OnboardingPagesViewProtocol: AnyObject {
    var presenter: OnboardingPagesPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
    var notificationController: LocalNotificationControllerProtocol! { get set }

    func setToggleStatus(isOn: Bool)
    func showSettingsNotificationDialogue()
}

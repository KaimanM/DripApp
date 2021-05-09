import UIKit

protocol OnboardingPagesViewProtocol: AnyObject {
    var presenter: OnboardingPagesPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
}

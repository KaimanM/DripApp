import UIKit

protocol OnboardingPagesViewProtocol: class {
    var presenter: OnboardingPagesPresenterProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
}

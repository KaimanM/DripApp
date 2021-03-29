import UIKit

final class OnboardingPagesScreenBuilder: ScreenBuilder {
    func build() -> OnboardingPagesView {

        let view = OnboardingPagesView()

        view.presenter = OnboardingPagesPresenter(view: view)
        view.userDefaultsController = UserDefaultsController.shared

        return view
    }
}

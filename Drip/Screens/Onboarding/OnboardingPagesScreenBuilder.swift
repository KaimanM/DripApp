import UIKit

final class OnboardingPagesScreenBuilder: ScreenBuilder {

    func build() -> OnboardingPagesView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.onboardingPages) as! OnboardingPagesView

        view.presenter = OnboardingPagesPresenter(view: view)

        return view
    }
}

import UIKit

final class OnboardingPagesScreenBuilder: ScreenBuilder {

    let notificationController = LocalNotificationController()

    func build() -> OnboardingPagesView {

        let view = OnboardingPagesView()

        view.presenter = OnboardingPagesPresenter(view: view)
        view.userDefaultsController = UserDefaultsController.shared
        view.notificationController = notificationController

        return view
    }
}

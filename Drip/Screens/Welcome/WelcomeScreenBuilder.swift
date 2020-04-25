import UIKit

final class WelcomeScreenBuilder: ScreenBuilder {

    func build() -> WelcomeView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.welcome) as! WelcomeView

        view.presenter = WelcomePresenter(view: view)

        return view
    }
}

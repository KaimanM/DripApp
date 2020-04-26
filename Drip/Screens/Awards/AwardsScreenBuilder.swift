import UIKit

final class AwardsScreenBuilder: ScreenBuilder {

    func build() -> AwardsView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.awards) as! AwardsView

        view.presenter = AwardsPresenter(view: view)

        return view
    }
}

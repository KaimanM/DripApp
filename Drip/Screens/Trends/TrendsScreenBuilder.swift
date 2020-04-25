import UIKit

final class TrendsScreenBuilder: ScreenBuilder {

    func build() -> TrendsView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.trends) as! TrendsView

        view.presenter = TrendsPresenter(view: view)

        return view
    }
}

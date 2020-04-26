import UIKit

final class AboutScreenBuilder: ScreenBuilder {

    func build() -> AboutView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.about) as! AboutView

        view.presenter = AboutPresenter(view: view)

        return view
    }
}

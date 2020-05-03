import UIKit

final class TodayScreenBuilder: ScreenBuilder {

    func build() -> TodayView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.today) as! TodayView

        view.presenter = TodayPresenter(view: view)

        return view
    }
}

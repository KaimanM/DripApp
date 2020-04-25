import UIKit

final class HistoryScreenBuilder: ScreenBuilder {

    func build() -> HistoryView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.history) as! HistoryView

        view.presenter = HistoryPresenter(view: view)

        return view
    }
}

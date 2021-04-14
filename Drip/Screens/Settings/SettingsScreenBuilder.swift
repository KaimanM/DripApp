import UIKit

final class SettingsScreenBuilder: ScreenBuilder {

    func build() -> SettingsView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.settings) as! SettingsView

        view.presenter = SettingsPresenter(view: view)

        return view
    }
}

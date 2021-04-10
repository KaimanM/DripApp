import UIKit

final class SettingsDetailScreenBuilder: ScreenBuilder {

    func build() -> AwardsDetailView {
        let view = AwardsDetailView()

        view.presenter = AwardsDetailPresenter(view: view)

        return view
    }
}

import UIKit

final class AwardsScreenBuilder: ScreenBuilder {

    func build() -> AwardsView {
        let view = AwardsView()

        view.presenter = AwardsPresenter(view: view)

        return view
    }
}

import UIKit

final class AwardsDetailScreenBuilder: ScreenBuilder {

    func build() -> AwardsDetailView {
        let view = AwardsDetailView()

        view.presenter = AwardsDetailPresenter(view: view)

        return view
    }
}

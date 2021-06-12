import UIKit

final class WhatsNewScreenBuilder: ScreenBuilder {

    let featureItems: [WhatsNewItem]

    init(featureItems: [WhatsNewItem]) {
        self.featureItems = featureItems
    }

    func build() -> WhatsNewView {
        let view = WhatsNewView()
        view.presenter = WhatsNewPresenter(view: view)
        view.featureItems = featureItems
        return view
    }
}

struct WhatsNewItem {
    let title: String
    let subtitle: String
    let image: UIImage
}

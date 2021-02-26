import Foundation
import UIKit

final class TabBarPresenter: TabBarPresenterProtocol {
    weak var view: TabBarViewProtocol?

    init(view: TabBarViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        // Initialises shared data model between child view controllers of tab bar
        let dataModel = DataModel()

        // Injects dataModel into each child view controller
        if let navControllers = view?.vcs as? [DarkNavController] {
            for navController in navControllers {
                if let view = navController.viewControllers[0] as? DataModelViewProtocol {
                    view.dataModel = dataModel
                }
            }
        }
    }
}

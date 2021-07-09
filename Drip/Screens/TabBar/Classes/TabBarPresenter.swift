import Foundation
import UIKit

final class TabBarPresenter: TabBarPresenterProtocol {
    weak var view: TabBarViewProtocol?

    init(view: TabBarViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        // Injects CoreDataController into each child view controller
        if let navControllers = view?.vcs as? [DarkNavController] {
            for navController in navControllers {
                if let view = navController.viewControllers[0] as? PersistentDataViewProtocol {
                    view.coreDataController = CoreDataController.shared
                    view.userDefaultsController = UserDefaultsController.shared
                }

                // TODO: Remove print statements
                if let view = navController.viewControllers[0] as? HealthKitViewProtocol {
                    view.healthKitController = HealthKitController.shared
                    print("added to vc")
                } else {
                    print("does not conform to hkview protocol")
                }
            }
        }
    }
}

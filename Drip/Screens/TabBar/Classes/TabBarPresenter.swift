import Foundation
import UIKit

final class TabBarPresenter: TabBarPresenterProtocol {
    weak var view: TabBarViewProtocol?
    
    init(view: TabBarViewProtocol) {
        self.view = view
    }
    
}

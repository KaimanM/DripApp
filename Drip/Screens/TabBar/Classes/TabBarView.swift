import UIKit

final class TabBarView: DarkTabBarController, TabBarViewProtocol, UITabBarControllerDelegate {
    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }
    
    func updateTitle(title: String?) {
        self.title = title
    }
    
    var presenter: TabBarPresenterProtocol!
    
    func select(tab: TabBarElement) {
        guard let index = viewControllers?.firstIndex(where: {
            $0.tabBarItem.tag == tab.rawValue
        }) else {
            return
        }
        selectedIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = 0
    }    
    
}

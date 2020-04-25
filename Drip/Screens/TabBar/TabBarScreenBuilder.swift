import UIKit

enum TabBarElement: Int, CaseIterable {
    case welcome
    case welcome2
}

final class TabBarScreenBuilder: ScreenBuilder {
    
    func build() -> TabBarView {
        let view = UIViewController.create(.tabBar) as! TabBarView
        
        view.presenter = TabBarPresenter(view: view)
        
        view.viewControllers = TabBarElement.allCases.map{
            $0.viewController
        }
        
        return view
    }
}

extension TabBarElement {
    var title: String {
        switch self {
        case .welcome:
            return "Welcome"
        case .welcome2:
            return "Welcome2"
        }
    }
    
    var viewController: UIViewController {
        let view: UIViewController
        switch self {
        case .welcome:
            view = DarkNavController(rootViewController: WelcomeScreenBuilder().build())
        case .welcome2:
            view = DarkNavController(rootViewController: WelcomeScreenBuilder().build())
        }
        
        view.tabBarItem = tabBarItem
        
        return view
    }
    
    var tabBarItem: UITabBarItem {
        let selectedIcon: UIImage?
        let unselectedIcon: UIImage?
        
        switch self {
        case .welcome:
            selectedIcon = UIImage(systemName: "view.2d")
            unselectedIcon = UIImage(systemName: "view.3d")
        case .welcome2:
            selectedIcon = UIImage(systemName: "bold")
            unselectedIcon = UIImage(systemName: "underline")
        }
        
        let item = UITabBarItem(title: title, image: unselectedIcon, selectedImage: selectedIcon)
        return item
    }
}

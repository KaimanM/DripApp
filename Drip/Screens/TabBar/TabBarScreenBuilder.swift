import UIKit

enum TabBarElement: Int, CaseIterable {
    case history
    case welcome
    case welcome2
}

final class TabBarScreenBuilder: ScreenBuilder {

    func build() -> TabBarView {
        //swiftlint:disable:next force_cast
        let view = UIViewController.create(.tabBar) as! TabBarView

        view.presenter = TabBarPresenter(view: view)

        view.viewControllers = TabBarElement.allCases.map {
            $0.viewController
        }

        return view
    }
}

extension TabBarElement {
    var title: String {
        switch self {
        case .history:
            return "History"
        case .welcome:
            return "Welcome"
        case .welcome2:
            return "Welcome2"
        }
    }

    var viewController: UIViewController {
        let view: UIViewController
        switch self {
        case .history:
            view = DarkNavController(rootViewController: HistoryScreenBuilder().build())
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

        switch self {
        case .history:
            selectedIcon = UIImage(systemName: "return")
        case .welcome:
            selectedIcon = UIImage(named: "bottle")
        case .welcome2:
            selectedIcon = UIImage(systemName: "bold")
        }

        let item = UITabBarItem(title: title, image: selectedIcon, tag: self.rawValue)
        return item
    }
}

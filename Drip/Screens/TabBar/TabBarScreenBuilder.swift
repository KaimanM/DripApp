import UIKit

enum TabBarElement: Int, CaseIterable {
    case history
    case trends
    case welcome
    case awards
    case about
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
        case .trends:
            return "Trends"
        case .welcome:
            return "Welcome"
        case .awards:
            return "Awards"
        case .about:
            return "About"
        }
    }

    var viewController: UIViewController {
        let view: UIViewController
        switch self {
        case .history:
            view = DarkNavController(rootViewController: HistoryScreenBuilder().build())
        case .trends:
            view = DarkNavController(rootViewController: TrendsScreenBuilder().build())
        case .welcome:
            view = DarkNavController(rootViewController: WelcomeScreenBuilder().build())
        case .awards:
            view = DarkNavController(rootViewController: AwardsScreenBuilder().build())
        case .about:
            view = DarkNavController(rootViewController: AboutScreenBuilder().build())
        }

        view.tabBarItem = tabBarItem

        return view
    }

    var tabBarItem: UITabBarItem {
        let selectedIcon: UIImage?

        switch self {
        case .history:
            selectedIcon = UIImage(systemName: "list.bullet")
        case .trends:
            selectedIcon = UIImage(systemName: "calendar")
        case .welcome:
            selectedIcon = UIImage(systemName: "square.and.pencil")
        case .awards:
            selectedIcon = UIImage(systemName: "shield")
        case .about:
            selectedIcon = UIImage(systemName: "questionmark.circle")
        }

        let item = UITabBarItem(title: title, image: selectedIcon, tag: self.rawValue)
        return item
    }
}

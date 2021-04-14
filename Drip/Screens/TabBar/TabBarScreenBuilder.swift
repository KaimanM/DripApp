import UIKit

enum TabBarElement: Int, CaseIterable {
    case history
    case trends
    case today
    case awards
    case settings
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
        case .today:
            return "Today"
        case .awards:
            return "Awards"
        case .settings:
            return "Settings"
        }
    }

    var viewController: UIViewController {
        let view: UIViewController
        switch self {
        case .history:
            view = DarkNavController(rootViewController: HistoryScreenBuilder().build())
        case .trends:
            view = DarkNavController(rootViewController: TrendsScreenBuilder().build())
        case .today:
            view = DarkNavController(rootViewController: TodayScreenBuilder().build())
        case .awards:
            view = DarkNavController(rootViewController: AwardsScreenBuilder().build())
        case .settings:
            view = DarkNavController(rootViewController: SettingsScreenBuilder().build())
        }

        view.tabBarItem = tabBarItem

        return view
    }

    var tabBarItem: UITabBarItem {
        let selectedIcon: UIImage?

        switch self {
        case .history:
            selectedIcon = UIImage(systemName: "calendar")
        case .trends:
            selectedIcon = UIImage(systemName: "text.book.closed")
        case .today:
            selectedIcon = UIImage(systemName: "square.and.pencil")
        case .awards:
            selectedIcon = UIImage(systemName: "crown")
        case .settings:
            selectedIcon = UIImage(systemName: "gear")
        }

        let item = UITabBarItem(title: title, image: selectedIcon, tag: self.rawValue)
        return item
    }
}

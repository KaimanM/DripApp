import UIKit

final class TabBarView: DarkTabBarController, TabBarViewProtocol, UITabBarControllerDelegate {

    var vcs: [UIViewController] = []

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func updateTitle(title: String?) {
        self.title = title
    }

    var presenter: TabBarPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // checks if there are child views of tab bar view controller and sets vcs to that value.
        if let childViews = viewControllers {
            vcs = childViews
            presenter.onViewDidLoad()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedIndex = 2
    }

}

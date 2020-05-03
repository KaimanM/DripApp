import UIKit

final class TabBarView: DarkTabBarController, TabBarViewProtocol, UITabBarControllerDelegate {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedIndex = 2
    }

}

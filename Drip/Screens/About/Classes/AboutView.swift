import UIKit

final class AboutView: UIViewController, AboutViewProtocol, PersistentDataViewProtocol {

    var presenter: AboutPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Add fake data", for: .normal)
        button.backgroundColor = .purple
        return button
    }()

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(button)
        button.anchor(leading: view.leadingAnchor,
                      trailing: view.trailingAnchor,
                      padding: .init(top: 0, left: 20, bottom: 0, right: 20),
                      size: .init(width: 0, height: 42))
        button.centerVerticallyInSuperview()
        button.addTarget(self, action: #selector(addFakeData), for: .touchUpInside)
    }

    @objc func addFakeData() {
        var date = Date()
        for _ in 0...365 {
            coreDataController.addDrinkForDay(name: "Water",
                                                    volume: 500,
                                                    imageName: "waterbottle.svg",
                                                    timeStamp: date)
            coreDataController.addDrinkForDay(name: "Coffee",
                                              volume: 50,
                                              imageName: "coffee.svg",
                                              timeStamp: date)
            coreDataController.addDrinkForDay(name: "Milk",
                                              volume: 300,
                                              imageName: "milk.svg",
                                              timeStamp: date)
            coreDataController.addDrinkForDay(name: "Tea",
                                              volume: 1000,
                                              imageName: "tea.svg",
                                              timeStamp: date)
            coreDataController.addDrinkForDay(name: "Beer",
                                              volume: 300,
                                              imageName: "beer.svg",
                                              timeStamp: date)
            coreDataController.addDrinkForDay(name: "smoothie",
                                              volume: 450,
                                              imageName: "smoothie.svg",
                                              timeStamp: date)
            coreDataController.addDrinkForDay(name: "soda",
                                                    volume: 150,
                                                    imageName: "soda.svg",
                                                    timeStamp: date)
            date = date.dayBefore
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func showView(_ view: UIViewController) {
        show(view, sender: self)
    }

    func updateTitle(title: String) {
        self.title = title
    }

}

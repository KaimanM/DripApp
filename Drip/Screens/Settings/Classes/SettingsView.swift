import UIKit

final class SettingsView: UIViewController, SettingsViewProtocol, PersistentDataViewProtocol {

    var presenter: SettingsPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!

    let tableView = UITableView(frame: .zero, style: .grouped)

    let cellId = "settingsCell"

    let cellDataSection1: [SettingsCellData] = [
        SettingsCellData(title: "Edit Name", imageName: "square.and.pencil", backgroundColour: .systemBlue),
        SettingsCellData(title: "Edit Goal", imageName: "slider.horizontal.3", backgroundColour: .systemIndigo),
        SettingsCellData(title: "Edit Favourites", imageName: "bookmark", backgroundColour: .systemRed),
        SettingsCellData(title: "Drink Coefficients", imageName: "number", backgroundColour: .systemTeal)
    ]

    let cellDataSection2: [SettingsCellData] = [
        SettingsCellData(title: "About", imageName: "at", backgroundColour: .systemBlue),
        SettingsCellData(title: "Thanks to", imageName: "gift", backgroundColour: .systemIndigo),
        SettingsCellData(title: "Privacy Policy", imageName: "hand.raised", backgroundColour: .systemGreen),
        SettingsCellData(title: "Rate Drip", imageName: "heart.fill", backgroundColour: .systemRed)
    ]

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 44

        view.addSubview(tableView)
        tableView.fillSuperView()

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

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cellDataSection1.count
        } else {
            return cellDataSection2.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as? SettingsCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.textLabel?.text = cellDataSection1[indexPath.row].title
            cell.iconImageView.image = UIImage(systemName: cellDataSection1[indexPath.row].imageName)
            cell.imageContainerView.backgroundColor = cellDataSection1[indexPath.row].backgroundColour
        } else {
            cell.textLabel?.text = cellDataSection2[indexPath.row].title
            cell.iconImageView.image = UIImage(systemName: cellDataSection2[indexPath.row].imageName)
            cell.imageContainerView.backgroundColor = cellDataSection2[indexPath.row].backgroundColour
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}

struct SettingsCellData {
    var title: String
    var imageName: String
    var backgroundColour: UIColor

    init(title: String, imageName: String, backgroundColour: UIColor) {
        self.title = title
        self.imageName = imageName
        self.backgroundColour = backgroundColour
    }
}

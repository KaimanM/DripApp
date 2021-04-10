import UIKit

final class SettingsView: UIViewController, SettingsViewProtocol, PersistentDataViewProtocol {

    var presenter: SettingsPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!

    let tableView = UITableView(frame: .zero, style: .grouped)

    let cellId = "settingsCell"

    let cellDataSection1: [SettingsCellData] = [
        SettingsCellData(title: "Name", imageName: "square.and.pencil", backgroundColour: .systemBlue),
        SettingsCellData(title: "Goal", imageName: "slider.horizontal.3", backgroundColour: .systemIndigo),
        SettingsCellData(title: "Favourites", imageName: "star", backgroundColour: .systemRed),
        SettingsCellData(title: "Drink Coefficients", imageName: "info.circle", backgroundColour: .systemTeal)
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
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        tableView.fillSuperView()

        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)

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

    func pushView(_ view: UIViewController) {
        self.navigationController!.pushViewController(view, animated: true)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func changeNameTapped() {
        let name = userDefaultsController.name
        let message = "We're currently calling you \"\(name)\". What should we call you instead?"
        let alertContoller = UIAlertController(title: "Change Name",
                                               message: message,
                                               preferredStyle: .alert)

        alertContoller.addTextField()
        alertContoller.textFields![0].keyboardType = UIKeyboardType.alphabet

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertContoller] _ in
            if let answer: String = alertContoller.textFields![0].text {
                self.userDefaultsController.name = answer
            } else {
                print("invalid")
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertContoller.addAction(cancelAction)
        alertContoller.addAction(submitAction)

        present(alertContoller, animated: true)
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
            return 120
        }
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        if section == 0 {

            let containerView = UIView()

            let imageView = UIImageView()
            imageView.image = Bundle.main.icon
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
//            imageView.anchor(size: .init(width: 80, height: 80))

            let appNameLabel = UILabel()
            appNameLabel.text = "Drip \(Bundle.main.appVersion)"
            appNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
            appNameLabel.textColor = .whiteText

            let devNameLabel = UILabel()
            devNameLabel.text = "by Kaiman Mehmet"
            devNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
            devNameLabel.textColor = .lightGray

            containerView.addSubview(imageView)
            containerView.addSubview(appNameLabel)
            containerView.addSubview(devNameLabel)

            imageView.anchor(top: containerView.topAnchor,
                             leading: containerView.leadingAnchor,
                             bottom: containerView.bottomAnchor,
                             size: .init(width: 80, height: 80))

            appNameLabel.anchor(top: containerView.topAnchor,
                                leading: imageView.trailingAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: .init(top: 20, left: 10, bottom: 0, right: 10))

            devNameLabel.anchor(leading: imageView.trailingAnchor,
                                bottom: containerView.bottomAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: .init(top: 0, left: 10, bottom: 20, right: 10))

            view.addSubview(containerView)
            containerView.centerInSuperview()
        }
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            changeNameTapped()
        case 1:
            pushView(SettingsDetailScreenBuilder(type: .goal,
                                                 userDefaultsController: userDefaultsController).build())
        case 2:
            pushView(SettingsDetailScreenBuilder(type: .favourite,
                                                 userDefaultsController: userDefaultsController).build())
        default:
            print("do nothing")
        }

        tableView.deselectRow(at: indexPath, animated: true)
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

import UIKit
import SafariServices

class SettingsDetailView: UIViewController, SettingsDetailViewProtocol, HealthKitViewProtocol {

    var presenter: SettingsDetailPresenterProtocol!
    var settingsType: SettingsType!
    var userDefaultsController: UserDefaultsControllerProtocol!
    var healthKitController: HealthKitControllerProtocol!

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .infoPanelBG
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        label.textAlignment = .center
        return label
    }()

    let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .whiteText
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    let scrollView = UIScrollView()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.contentInset.bottom = 5
        tableView.contentInset.top = -30 // Removes padding caused by grouped style
        return tableView
    }()

    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .dripMerged
        return toggle
    }()

    let cellId = "cellId"

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: true)

    var tableViewHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        presenter.onViewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        drinksLauncher.removeFromWindow()
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch settingsType {
        case .coefficient:
            toggle.isOn = userDefaultsController.useDrinkCoefficients
        default:
            break
        }
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func showHealthKitDialogue() {
        DispatchQueue.main.async {
            let message = "To enable HealthKit integration, please open the Health App and enable Drip as a source."
            let alertContoller = UIAlertController(title: "Health Kit",
                                                   message: message,
                                                   preferredStyle: .alert)

            let healthKitAction = UIAlertAction(title: "Open Health", style: .default) { _ in
                if let healthAppURL = URL(string: "x-apple-health://") {
                    if UIApplication.shared.canOpenURL(healthAppURL) {
                        UIApplication.shared.open(healthAppURL)
                    }
                }
            }

            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)

            alertContoller.addAction(cancelAction)
            alertContoller.addAction(healthKitAction)

            self.present(alertContoller, animated: true)
        }
    }

    @objc func switchValueDidChange(_ sender: UISwitch!) {
        switch settingsType {
        case .coefficient:
            presenter.setCoefficientBool(isEnabled: sender.isOn)
        case .healthKit:
            presenter.setHealthKitBool(isEnabled: sender.isOn)
        default:
            print("do nothing")
        }
    }

    func setToggleStatus(isOn: Bool) {
        DispatchQueue.main.async {
            self.toggle.isOn = isOn
        }
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        let step: Float = 50
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue

        presenter.updateGoalValue(newGoal: Double(roundedStepValue))
        goalLabel.text = "\(Int(roundedStepValue))ml"
    }

    @objc func saveButtonAction() {
        presenter.saveButtonTapped()
    }

    func popView() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func showAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}

// MARK: - Collection View Deleagate & DataSource -
extension SettingsDetailView: UICollectionViewDataSource, UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.setSelectedFavourite(selected: indexPath.item)
        drinksLauncher.showDrinks()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell,
           let cellData = presenter?.drinkForCellAt(index: indexPath.item) {
            drinkCell.imageView.image = UIImage(named: cellData.imageName)
            drinkCell.nameLabel.text = "\(Int(cellData.volume))ml"

           cell = drinkCell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height/2)
    }
}

extension SettingsDetailView: DrinksLauncherDelegate {
    func didAddDrink(beverage: Beverage, volume: Double) {
        presenter.addFavourite(beverage: beverage, volume: volume)
    }
}

// MARK: - Table View Deleagate & DataSource -
extension SettingsDetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch settingsType {
        case .coefficient:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as?
                    CoefficientTableViewCell else {
                return UITableViewCell()
            }
            let cellData = presenter.coefficientCellDataForRow(row: indexPath.row)
            cell.drinkNameLabel.text = cellData.name
            cell.drinkImageView.image = UIImage(named: cellData.imageName)
            cell.coeffientLabel.text = "\(cellData.coefficient)"
            return cell
        case .attribution:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) else {
                return UITableViewCell() }
            cell.backgroundColor = .infoPanelBG
            cell.textLabel?.textColor = .whiteText
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            cell.accessoryView = chevronImageView
            cell.tintColor = UIColor.white.withAlphaComponent(0.2)
            cell.textLabel?.text = presenter.attributionTitleForRow(row: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingsType {
        case .attribution:
            if let url = presenter.getAttributionURLforRow(row: indexPath.row) {
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredBarTintColor = .black
                safariVC.preferredControlTintColor = .whiteText
                safariVC.modalPresentationStyle = .popover
                self.navigationController?.present(safariVC, animated: true, completion: nil)
            } else {
                presenter.creditAlertControllerForRow(row: indexPath.row)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

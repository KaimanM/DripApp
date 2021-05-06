import UIKit
import SafariServices

class SettingsDetailView: UIViewController, SettingsDetailViewProtocol {

    var presenter: SettingsDetailPresenterProtocol!
    var settingsType: SettingsType!
    var userDefaultsController: UserDefaultsControllerProtocol!

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

    func setupButton() {
        view.addSubview(saveButton)
        saveButton.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                          size: .init(width: 0, height: 50))
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }

    func setupStackView() {
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: saveButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))
    }

    func setupGoalView(currentGoal: Double, headingText: String, bodyText: String) {
        goalLabel.text = "\(Int(currentGoal))ml"

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        saveButton.setTitle("Save", for: .normal)

        setupButton()
        setupStackView()

        let slider: UISlider = {
            let slider = UISlider()
            slider.minimumValue = 1000
            slider.maximumValue = 4000
            slider.isContinuous = true
            slider.tintColor = UIColor.dripMerged
            slider.value = Float(currentGoal)
            return slider
        }()

        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(), spacer5 = UIView()

        let subViews = [spacer1, headingLabel, spacer2, bodyLabel, spacer3, goalLabel, spacer4, slider, spacer5]
        subViews.forEach({stackView.addArrangedSubview($0)})

        spacer2.equalHeightTo(spacer1, multiplier: 0.1)
        spacer3.equalHeightTo(spacer1, multiplier: 0.5)
        spacer4.equalHeightTo(spacer1, multiplier: 0.25)
        spacer5.equalHeightTo(spacer1, multiplier: 0.9)
    }

    func setupFavouritesView(headingText: String, bodyText: String) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        drinksLauncher.delegate = self

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        saveButton.setTitle("Finished", for: .normal)

        setupButton()
        setupStackView()

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(),
            collectionViewContainer = UIView()

        collectionViewContainer.addSubview(collectionView)

        collectionView.anchor(top: collectionViewContainer.topAnchor,
                              leading: nil,
                              bottom: collectionViewContainer.bottomAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 250, height: 250))
        collectionView.centerHorizontallyInSuperview()

        let subViews = [spacer1, headingLabel, spacer2, bodyLabel, spacer3, collectionViewContainer, spacer4]
        subViews.forEach({stackView.addArrangedSubview($0)})

        spacer4.equalHeightTo(spacer1, multiplier: 0.9)
        spacer3.equalHeightTo(spacer1, multiplier: 0.5)
        spacer2.equalHeightTo(spacer1, multiplier: 0.1)

    }

    // swiftlint:disable:next function_body_length
    func setupCoefficientView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoefficientTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false

        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            return scrollView
        }()

        let childStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            return stackView
        }()

        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        let toggleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .whiteText
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = "Enable Drink Coefficients"
            return label
        }()

        let topContainerView = UIView(), lineView1 = UIView(), lineView2 = UIView()

        view.addSubview(scrollView)
        scrollView.addSubview(childStackView)

        lineView1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView2.backgroundColor = UIColor.white.withAlphaComponent(0.2)

        let subViews = [headingLabel, bodyLabel, lineView1, toggleLabel, toggle, lineView2]
        subViews.forEach({topContainerView.addSubview($0)})

        let arrangedSubviews = [topContainerView, tableView]
        arrangedSubviews.forEach({childStackView.addArrangedSubview($0)})

        scrollView.fillSuperView()
        childStackView.fillSuperView()
        childStackView.setEqualWidthTo(scrollView)

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        let tableViewHeight = (presenter.numberOfRowsInSection()*90)+10

        tableView.anchor(size: .init(width: 0,
                                     height: tableViewHeight))
        headingLabel.anchor(top: topContainerView.topAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        lineView1.anchor(top: bodyLabel.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
        toggle.anchor(top: lineView1.bottomAnchor,
                      trailing: topContainerView.trailingAnchor,
                      padding: .init(top: 5, left: 0, bottom: 0, right: 20))
        toggleLabel.anchor(top: lineView1.bottomAnchor,
                           leading: topContainerView.leadingAnchor,
                           bottom: lineView2.topAnchor,
                           trailing: toggle.leadingAnchor,
                           padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        lineView2.anchor(top: toggle.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         bottom: topContainerView.bottomAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
    }

    @objc func switchValueDidChange(_ sender: UISwitch!) {
            presenter.setCoefficientBool(isEnabled: sender.isOn)
    }

    func setupAttributionView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.tableFooterView = UIView()

        let subViews = [headingLabel, bodyLabel, tableView]
        subViews.forEach({view.addSubview($0)})

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        headingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        tableView.anchor(top: bodyLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }

    func setupAboutView(headingText: String, bodyText: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "portrait")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        saveButton.setTitle("Back", for: .normal)

        setupButton()

        let subViews = [imageView, headingLabel, bodyLabel]
        subViews.forEach({view.addSubview($0)})

        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                         size: .init(width: 150, height: 150))
        imageView.centerHorizontallyInSuperview()
        headingLabel.anchor(top: imageView.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))

    }

    // swiftlint:disable:next function_body_length
    func setupNotificationsView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false

        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            return scrollView
        }()

        let childStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            return stackView
        }()

        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        let toggleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .whiteText
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = "Enable Reminders"
            return label
        }()

        let topContainerView = UIView(), lineView1 = UIView(), lineView2 = UIView(), lineView3 = UIView()

        let textField: UITextField = {
            let textField = UITextField()
            textField.text = "8 Daily Reminders"
            textField.textColor = .whiteText
//            textField.backgroundColor = .purple
            textField.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 5
            textField.textAlignment = .center
            return textField
        }()

        view.addSubview(scrollView)
        scrollView.addSubview(childStackView)

        lineView1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView2.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView3.backgroundColor = UIColor.white.withAlphaComponent(0.2)

        let subViews = [headingLabel, bodyLabel, lineView1, toggleLabel, toggle, lineView2, textField, lineView3]
        subViews.forEach({topContainerView.addSubview($0)})

        let arrangedSubviews = [topContainerView, tableView]
        arrangedSubviews.forEach({childStackView.addArrangedSubview($0)})

        scrollView.fillSuperView()
        childStackView.fillSuperView()
        childStackView.setEqualWidthTo(scrollView)

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        let tableViewHeight = (presenter.numberOfRowsInSection()*60)+10

        tableView.anchor(size: .init(width: 0,
                                     height: tableViewHeight))
        headingLabel.anchor(top: topContainerView.topAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        lineView1.anchor(top: bodyLabel.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
        toggle.anchor(top: lineView1.bottomAnchor,
                      trailing: topContainerView.trailingAnchor,
                      padding: .init(top: 5, left: 0, bottom: 0, right: 20))
        toggleLabel.anchor(top: lineView1.bottomAnchor,
                           leading: topContainerView.leadingAnchor,
                           bottom: lineView2.topAnchor,
                           trailing: toggle.leadingAnchor,
                           padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        lineView2.anchor(top: toggle.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
        textField.anchor(top: lineView2.bottomAnchor,
                         padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                         size: .init(width: 200, height: 30))
        textField.centerHorizontallyInSuperview()
        lineView3.anchor(top: textField.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         bottom: topContainerView.bottomAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
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
        case .notifications:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as?
                    NotificationsTableViewCell else {
                return UITableViewCell()
            }
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

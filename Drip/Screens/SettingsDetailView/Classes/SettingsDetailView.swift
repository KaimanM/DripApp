import UIKit

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
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.contentInset.bottom = 5
        return tableView
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

    func setupCoefficientView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoefficientTableViewCell.self, forCellReuseIdentifier: cellId)

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
    func didAddDrink(name: String, imageName: String, volume: Double) {
        presenter.addFavourite(name: name, volume: volume, imageName: imageName)
    }
}

extension SettingsDetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DrinksList().drinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as? CoefficientTableViewCell else {
            return UITableViewCell()
        }
        cell.drinkNameLabel.text = DrinksList().drinks[indexPath.row].name
        cell.drinkImageView.image = UIImage(named: DrinksList().drinks[indexPath.row].imageName)
        cell.coeffientLabel.text = "\(DrinksList().drinks[indexPath.row].coefficient)"

        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
}

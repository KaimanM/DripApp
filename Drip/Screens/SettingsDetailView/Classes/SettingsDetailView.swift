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

    let cellId = "cellId"

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: true)

    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black

        view.addSubview(saveButton)
        saveButton.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                          size: .init(width: 0, height: 50))

        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: saveButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))

        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)

        presenter.onViewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        drinksLauncher.removeFromWindow()
        super.viewWillDisappear(animated)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func setupGoalView(currentGoal: Double, headingText: String, bodyText: String) {
        goalLabel.text = "\(Int(currentGoal))ml"

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        saveButton.setTitle("Save", for: .normal)

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
//        delegate?.showDrinksForIndex(index: indexPath.item)
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

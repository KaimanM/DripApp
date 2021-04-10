import UIKit

class SettingsDetailView: UIViewController {

    enum SettingsType {
        case goal
        case favourite
        case coefficient
    }

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
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

    var goalValue: Double = 2000

    var settingsType: SettingsType = .favourite
    var userDefaultsController: UserDefaultsControllerProtocol! = UserDefaultsController.shared

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: true)


    var selectedFavourite = 0


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

        switch settingsType {
        case .goal:
            setupGoalView()
        case .favourite:
            setupFavouritesView()
        case .coefficient:
            print("do something")
        }
    }

    func setupGoalView() {
        title = "Change Goal"
        let currentGoal = userDefaultsController.drinkGoal
        goalLabel.text = "\(Int(currentGoal))ml"
        goalValue = currentGoal

        headingLabel.text = "Need to update your goal?"
        bodyLabel.text = """
                    This number is how much you plan to drink daily. It's okay if you need to change it. \
                    It's normal to play around with it a few times until it feels just right.

                    Adjust the slider below to amend it to your liking. \
                    It has a minimum of 1000ml and a maximum of 4000ml.

                    Note: Changing the goal does not affect days that already have a drink entry.
                    """

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

        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer4.translatesAutoresizingMaskIntoConstraints = false
        spacer5.translatesAutoresizingMaskIntoConstraints = false

        spacer5.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.9).isActive = true
        spacer3.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.5).isActive = true
        spacer4.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.25).isActive = true
        spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.1).isActive = true
    }

    func setupFavouritesView() {
        title = "Change Favourites"

        headingLabel.text = "Fancy a new favourite?"
        bodyLabel.text = """
                    To change a favourite, simply tap the one below you wish the change and choose a new drink \
                    and volume and we'll save it for you.
                    """

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(), spacer5 = UIView(), collectionViewContainer = UIView()

        collectionViewContainer.addSubview(collectionView)

        collectionView.anchor(top: collectionViewContainer.topAnchor,
                              leading: nil,
                              bottom: collectionViewContainer.bottomAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 250, height: 250))
        collectionView.centerHorizontallyInSuperview()

        let subViews = [spacer1, headingLabel, spacer2, bodyLabel, spacer3, collectionViewContainer, spacer5]
        subViews.forEach({stackView.addArrangedSubview($0)})

        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer4.translatesAutoresizingMaskIntoConstraints = false
        spacer5.translatesAutoresizingMaskIntoConstraints = false

        spacer5.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.9).isActive = true
        spacer3.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.5).isActive = true
//            spacer4.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.25).isActive = true
        spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.1).isActive = true
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        let step: Float = 50
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue

        goalValue = Double(roundedStepValue)
        goalLabel.text = "\(Int(roundedStepValue))ml"
    }

    @objc func saveButtonAction() {
        switch settingsType {
        case .goal:
            userDefaultsController.drinkGoal = goalValue
        default:
            print("do nothing")
        }

        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    // needs to be moved into presenter
    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double) {
        var volume: Double
        var imageName: String

        guard let userDefaults = userDefaultsController else { return ("waterbottle.svg", 100.0)}

        switch index {
        case 0:
            volume = userDefaults.favDrink1Volume
            imageName = userDefaults.favDrink1ImageName
        case 1:
            volume = userDefaults.favDrink2Volume
            imageName = userDefaults.favDrink2ImageName
        case 2:
            volume = userDefaults.favDrink3Volume
            imageName = userDefaults.favDrink3ImageName
        case 3:
            volume = userDefaults.favDrink4Volume
            imageName = userDefaults.favDrink4ImageName
        default:
            volume = userDefaults.favDrink1Volume
            imageName = userDefaults.favDrink1ImageName
        }

        return (imageName, volume)

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
        selectedFavourite = indexPath.item
        drinksLauncher.showDrinks()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell {
            let cellData = drinkForCellAt(index: indexPath.item)
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

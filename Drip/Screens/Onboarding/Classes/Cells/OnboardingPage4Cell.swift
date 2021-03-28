import UIKit

protocol OnboardingPage4CellDelegate: class {
    func didTapPage4Button()
}

class OnboardingPage4Cell: UICollectionViewCell {

    weak var delegate : OnboardingPage4CellDelegate?

    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .infoPanelBG
        button.layer.cornerRadius = 10
        return button
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let heading1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .whiteText
        label.text = "Finally, pick your favourites!"
        return label
    }()

    let body1Label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.text = """
                    Everyone has their favourites, we've started off by picking some of ours \
                    but tap any of them to change it!
                    """
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

    var selectedDrink = 0

    let userDefaults = UserDefaultsController.shared // TODO : needs to be init by dependency injection

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaults, isOnboarding: true)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        contentView.addSubview(continueButton)
        continueButton.anchor(leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                              size: .init(width: 0, height: 50))
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: continueButton.topAnchor,
                         trailing: contentView.trailingAnchor)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        populateStackView()
        drinksLauncher.delegate = self
    }

    func populateStackView() {
        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), titleContainerView = UIView()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Almost there"
            label.textColor = .whiteText
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()

        titleContainerView.addSubview(titleLabel)
        titleLabel.anchor(top: titleContainerView.topAnchor,
                               leading: titleContainerView.leadingAnchor,
                               bottom: titleContainerView.bottomAnchor,
                               trailing: titleContainerView.trailingAnchor,
                               padding: .init(top: 0, left: 25, bottom: 0, right: 25))

        let arrangedSubviews = [spacer1, titleContainerView, spacer2, contentStackView, spacer3]
        arrangedSubviews.forEach({stackView.addArrangedSubview($0)})

        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.5).isActive = true
        spacer1.heightAnchor.constraint(equalTo: spacer3.heightAnchor, multiplier: 0.6).isActive = true

        contentStackView.anchor(size: .init(width: contentView.frame.width, height: 370))
        populateContentStackView()
    }

    func populateContentStackView() {
        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(),
            topContainerView = UIView(), collectionViewContainer = UIView()

        let topSubviews = [heading1Label, body1Label]
        topSubviews.forEach({topContainerView.addSubview($0)})

        heading1Label.anchor(top: topContainerView.topAnchor,
                             leading: topContainerView.leadingAnchor,
                             trailing: topContainerView.trailingAnchor,
                             padding: .init(top: 0, left: 35, bottom: 0, right: 35))
        body1Label.anchor(top: heading1Label.bottomAnchor,
                             leading: topContainerView.leadingAnchor,
                             bottom: topContainerView.bottomAnchor,
                             trailing: topContainerView.trailingAnchor,
                             padding: .init(top: 5, left: 35, bottom: 0, right: 35))

        collectionViewContainer.addSubview(collectionView)

        collectionView.anchor(top: collectionViewContainer.topAnchor,
                              leading: nil,
                              bottom: collectionViewContainer.bottomAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 250, height: 250))
        collectionView.centerHorizontallyInSuperview()

        let arrangedSubviews = [spacer1, topContainerView, spacer2, collectionViewContainer, spacer3]
        arrangedSubviews.forEach({contentStackView.addArrangedSubview($0)})

        // constraints so content is just above offcenter in screen
        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer1.heightAnchor.constraint(equalTo: spacer2.heightAnchor, multiplier: 0.45).isActive = true
        spacer3.heightAnchor.constraint(equalTo: spacer2.heightAnchor, multiplier: 0.45).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
        drinksLauncher.removeFromWindow()
        delegate?.didTapPage4Button()
    }

}

// MARK: - Collection View Deleagate & DataSource -
extension OnboardingPage4Cell: UICollectionViewDataSource, UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDrink = indexPath.item
        drinksLauncher.showDrinks()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell {
            switch indexPath.item {
            case 0:
                drinkCell.nameLabel.text = "\(Int(userDefaults.favDrink1Volume))ml"
                drinkCell.imageView.image = UIImage(named: userDefaults.favDrink1ImageName)
            case 1:
                drinkCell.nameLabel.text = "\(Int(userDefaults.favDrink2Volume))ml"
                drinkCell.imageView.image = UIImage(named: userDefaults.favDrink2ImageName)
            case 2:
                drinkCell.nameLabel.text = "\(Int(userDefaults.favDrink3Volume))ml"
                drinkCell.imageView.image = UIImage(named: userDefaults.favDrink3ImageName)
            case 3:
                drinkCell.nameLabel.text = "\(Int(userDefaults.favDrink4Volume))ml"
                drinkCell.imageView.image = UIImage(named: userDefaults.favDrink4ImageName)
            default:
                drinkCell.nameLabel.text = "\(Int(userDefaults.favDrink1Volume))ml"
                drinkCell.imageView.image = UIImage(named: userDefaults.favDrink1ImageName)
            }

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

extension OnboardingPage4Cell: DrinksLauncherDelegate {
    func didAddDrink(name: String, imageName: String, volume: Double) {
        switch selectedDrink {
        case 0:
            userDefaults.favDrink1Name = name
            userDefaults.favDrink1Volume = volume
            userDefaults.favDrink1ImageName = imageName
        case 1:
            userDefaults.favDrink2Name = name
            userDefaults.favDrink2Volume = volume
            userDefaults.favDrink2ImageName = imageName
        case 2:
            userDefaults.favDrink3Name = name
            userDefaults.favDrink3Volume = volume
            userDefaults.favDrink3ImageName = imageName
        case 3:
            userDefaults.favDrink4Name = name
            userDefaults.favDrink4Volume = volume
            userDefaults.favDrink4ImageName = imageName
        default:
            break
        }
        collectionView.reloadData()
    }
}

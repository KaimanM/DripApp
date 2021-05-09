import UIKit

protocol OnboardingPage4CellDelegate: AnyObject {
    func didTapPage4Button()
    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double)
    func showDrinksForIndex(index: Int)
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

        spacer2.equalHeightTo(spacer1, multiplier: 0.5)
        spacer1.equalHeightTo(spacer3, multiplier: 0.6)

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
        spacer1.equalHeightTo(spacer2, multiplier: 0.45)
        spacer3.equalHeightTo(spacer2, multiplier: 0.45)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
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
        delegate?.showDrinksForIndex(index: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell,
           let cellData = delegate?.drinkForCellAt(index: indexPath.item) {
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

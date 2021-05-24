import UIKit

protocol OnboardingPage2CellDelegate: AnyObject {
    func didTapPage2Button()
}

class OnboardingPage2Cell: UICollectionViewCell {

    weak var delegate : OnboardingPage2CellDelegate?

    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .infoPanelBG
        button.layer.cornerRadius = 10
        return button
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    var titles = ["Let’s have a Drink!",
                  "Keep track of your data",
                  "Review your trends",
                  "Earn Achievements"]

    var bodys = ["Choose from a wide range of drinks, and let’s keep you hydrated.",
                 "Meet your daily goals and keep track of how much you are drinking daily.",
                 "See how you’re performing over time, and what trends you follow.",
                 "Sticking to your schedule can be tough, so we’re here to help reward that effort."]

    var imageNames = ["waterbottle.svg", "notebook.svg", "whiteboard.svg", "medal.svg"]

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let instructionsCellId = "instructionsCellId"

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

        populateStackView()
    }

    func populateStackView() {

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), titleContainerView = UIView()

        let titleLabelLine1: UILabel = {
            let label = UILabel()
            label.text = "Welcome to Drip"
            label.textColor = .whiteText
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()

        titleContainerView.addSubview(titleLabelLine1)
        titleLabelLine1.anchor(top: titleContainerView.topAnchor,
                               leading: titleContainerView.leadingAnchor,
                               bottom: titleContainerView.bottomAnchor,
                               trailing: titleContainerView.trailingAnchor,
                               padding: .init(top: 0, left: 25, bottom: 0, right: 25))

        let arrangedSubviews = [spacer1, titleContainerView, spacer2, collectionView, spacer3]
        arrangedSubviews.forEach({stackView.addArrangedSubview($0)})

        // constraints so content is just above offcenter in screen
        spacer2.equalHeightTo(spacer1, multiplier: 0.5)
        spacer1.equalHeightTo(spacer3, multiplier: 0.6)

        collectionView.anchor(size: .init(width: contentView.frame.width, height: 395))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InstructionsCell.self, forCellWithReuseIdentifier: instructionsCellId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
        delegate?.didTapPage2Button()
    }

}
extension OnboardingPage2Cell: UICollectionViewDataSource, UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let instructionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: instructionsCellId,
                                                              for: indexPath) as? InstructionsCell {

            instructionsCell.backgroundColor = .black
            instructionsCell.titleLabel.text = titles[indexPath.item]
            instructionsCell.bodyLabel.text = bodys[indexPath.item]
            instructionsCell.imageView.image = UIImage(named: imageNames[indexPath.item])
            cell = instructionsCell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: 80)
    }
}

private class InstructionsCell: UICollectionViewCell {

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .whiteText
        return label
    }()

    var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let subviews = [imageView, titleLabel, bodyLabel]
        subviews.forEach({contentView.addSubview($0)})

        imageView.anchor(leading: contentView.leadingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 10, right: 0),
                         size: .init(width: 55, height: 55))
        imageView.centerVerticallyInSuperview()

        titleLabel.anchor(top: contentView.topAnchor,
                          leading: imageView.trailingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 5, left: 10, bottom: 0, right: 0),
                          size: .init(width: 0, height: 16))

        bodyLabel.anchor(top: titleLabel.bottomAnchor,
                          leading: imageView.trailingAnchor,
                          bottom: contentView.bottomAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: .init(top: 0, left: 10, bottom: 5, right: 25),
                          size: .init(width: 0, height: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

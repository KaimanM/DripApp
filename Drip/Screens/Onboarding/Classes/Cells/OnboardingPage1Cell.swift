import UIKit

protocol OnboardingPage1CellDelegate: AnyObject {
    func didTapPage1Button()
}

class OnboardingPage1Cell: UICollectionViewCell {

    weak var delegate : OnboardingPage1CellDelegate?

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "The app aiming to help you take control of your water habits."
        label.textColor = .whiteText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let titleLabelLine2: UILabel = {
        let label = UILabel()
        label.text = "Drip"
        label.textColor = .dripMerged
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let titleLabelLine1: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.textColor = .whiteText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dripIcon")!.withTintColor(UIColor.dripMerged)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .dripMerged
        button.layer.cornerRadius = 10
        return button
    }()

    var containerView = UIView()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

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
        let spacer1 = UIView(), spacer2 = UIView()

        let arrangedSubViews = [spacer1, containerView, spacer2]
        arrangedSubViews.forEach({stackView.addArrangedSubview($0)})

        spacer1.equalHeightTo(spacer2, multiplier: 0.5)

        containerView.addSubview(bodyLabel)
        containerView.anchor(leading: stackView.leadingAnchor,
                             trailing: stackView.trailingAnchor)
        bodyLabel.anchor(leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor,
                         trailing: containerView.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))
        containerView.addSubview(titleLabelLine2)
        titleLabelLine2.anchor(leading: bodyLabel.leadingAnchor,
                               bottom: bodyLabel.topAnchor,
                               padding: .init(top: 0, left: 0, bottom: 5, right: 0))
        containerView.addSubview(titleLabelLine1)
        titleLabelLine1.anchor(leading: bodyLabel.leadingAnchor,
                               bottom: titleLabelLine2.topAnchor,
                               trailing: bodyLabel.trailingAnchor,
                               padding: .init(top: 0, left: 0, bottom: -10, right: 0))
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor,
                         leading: bodyLabel.leadingAnchor,
                         bottom: titleLabelLine1.topAnchor,
                         padding: .init(top: 0, left: 0, bottom: 5, right: 0),
                         size: .init(width: 80, height: 115))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
        delegate?.didTapPage1Button()
    }

}

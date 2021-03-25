import UIKit

protocol OnboardingPage1CellDelegate: class {
    func didTapButton()
}

class OnboardingViewCell: UICollectionViewCell {

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
//        label.backgroundColor = .red
        return label
    }()

    let titleLabelLine1: UILabel = {
        let label = UILabel()
        label.text = "Welcome to"
        label.textColor = .whiteText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
//        label.backgroundColor = .green
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        contentView.addSubview(bodyLabel)
        bodyLabel.anchor(leading: contentView.leadingAnchor,
                         bottom: contentView.centerYAnchor,
                         trailing: contentView.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))
        contentView.addSubview(titleLabelLine2)
        titleLabelLine2.anchor(top: nil,
                               leading: bodyLabel.leadingAnchor,
                               bottom: bodyLabel.topAnchor,
                               trailing: nil,
                               padding: .init(top: 0, left: 0, bottom: 5, right: 0))
        contentView.addSubview(titleLabelLine1)
        titleLabelLine1.anchor(top: nil,
                               leading: bodyLabel.leadingAnchor,
                               bottom: titleLabelLine2.topAnchor,
                               trailing: bodyLabel.trailingAnchor,
                               padding: .init(top: 0, left: 0, bottom: -10, right: 0))
        contentView.addSubview(imageView)
        imageView.anchor(top: nil,
                         leading: bodyLabel.leadingAnchor,
                         bottom: titleLabelLine1.topAnchor,
                         trailing: nil,
                         padding: .init(top: 0, left: 0, bottom: 5, right: 0),
                         size: .init(width: 80, height: 115))
        contentView.addSubview(continueButton)
        continueButton.anchor(top: nil,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                              size: .init(width: 0, height: 50))
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
        delegate?.didTapButton()
    }

}

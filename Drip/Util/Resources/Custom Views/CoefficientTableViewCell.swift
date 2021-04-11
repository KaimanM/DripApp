import UIKit

class CoefficientTableViewCell: UITableViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .infoPanelBG
        view.layer.cornerRadius = 10
        return view
    }()

    let imageContainerView = GradientView()
    let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(ofSize: 22, fontWeight: .semibold)
        label.textColor = .dripMerged
        label.adjustsFontSizeToFitWidth = true
        label.text = "Water"
        return label
    }()

    let coeffientLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(ofSize: 22, fontWeight: .semibold)
        label.textColor = .whiteText
        label.text = "0.87"
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             padding: .init(top: 5, left: 15, bottom: 5, right: 15),
                             size: .init(width: 0, height: 80))

        containerView.addSubview(imageContainerView)

        imageContainerView.anchor(leading: containerView.leadingAnchor,
                                  padding: .init(top: 0, left: 15, bottom: 0, right: 0),
                                  size: .init(width: 60, height: 60))
        imageContainerView.centerVerticallyInSuperview()
        imageContainerView.layer.cornerRadius = 30

        imageContainerView.addSubview(drinkImageView)
        drinkImageView.anchor(size: .init(width: 45,
                                         height: 45))
        drinkImageView.centerInSuperview()
        drinkImageView.image = UIImage(named: "waterbottle.svg")

        containerView.addSubview(drinkNameLabel)
        drinkNameLabel.anchor(leading: imageContainerView.trailingAnchor,
                              padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        drinkNameLabel.centerVerticallyInSuperview()

        containerView.addSubview(coeffientLabel)
        coeffientLabel.anchor(leading: drinkNameLabel.trailingAnchor,
                              trailing: containerView.trailingAnchor,
                              padding: .init(top: 0, left: 10, bottom: 0, right: 15),
                              size: .init(width: 55, height: 0))
        coeffientLabel.centerVerticallyInSuperview()
//        coeffientLabel.backgroundColor = .purple
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}

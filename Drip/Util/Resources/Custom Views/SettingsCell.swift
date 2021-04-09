import UIKit

class SettingsCell: UITableViewCell {

    let imageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "gear")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageContainerView)
        imageContainerView.anchor(leading: contentView.leadingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                             size: .init(width: 28, height: 28))
        imageContainerView.centerVerticallyInSuperview()

        imageContainerView.addSubview(iconImageView)
        iconImageView.anchor(size: .init(width: imageContainerView.frame.height/1.5,
                                         height: imageContainerView.frame.width/1.5))
        iconImageView.centerInSuperview()

        separatorInset.left = 60
//        accessoryType = .disclosureIndicator

        textLabel?.textColor = .whiteText
        backgroundColor = .infoPanelBG

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView = chevronImageView
        tintColor = UIColor.white.withAlphaComponent(0.2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

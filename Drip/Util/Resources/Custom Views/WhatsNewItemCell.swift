import UIKit

class WhatsNewItemCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .whiteText
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .whiteText
        return label
    }()

    let featureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .dripMerged
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(featureImage)
        backgroundColor = .clear

        featureImage.anchor(leading: contentView.leadingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 10, right: 0),
                            size: .init(width: 50, height: 50))
        featureImage.centerVerticallyInSuperview()

        titleLabel.anchor(top: contentView.topAnchor,
                          leading: featureImage.trailingAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: .init(top: 10, left: 15, bottom: 0, right: 20))

        subtitleLabel.anchor(top: titleLabel.bottomAnchor,
                             leading: titleLabel.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: titleLabel.trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 10, right: 0))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

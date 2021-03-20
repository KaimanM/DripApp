import UIKit

class QuickDrinkView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coffee.svg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 60).isActive = true
        layer.cornerRadius = 5

        addSubview(imageView)
        addSubview(titleLabel)

        imageView.anchor(top: self.topAnchor,
                         leading: self.leadingAnchor, bottom: titleLabel.topAnchor,
                         trailing: self.trailingAnchor,
                         padding: .init(top: 10, left: 5, bottom: 10, right: 5))

        titleLabel.anchor(top: nil,
                          leading: self.leadingAnchor,
                          bottom: self.bottomAnchor,
                          trailing: self.trailingAnchor,
                          padding: .zero, size: .init(width: 0, height: 20))
    }
}

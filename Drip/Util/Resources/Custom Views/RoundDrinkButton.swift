import UIKit

class RoundDrinkButton: UIButton {

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(named: "roundButtonBackground")
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(named: "roundButtonBackground")?.cgColor
        self.setImage(UIImage(named: "waterbottle.svg"), for: .normal)
        self.setTitle("", for: .normal)
        self.contentMode = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.tintColor = UIColor.white.withAlphaComponent(0.8)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }

}

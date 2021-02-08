import UIKit

class RoundDrinkButton: UIButton {

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .black
        self.layer.cornerRadius = 0.5 * self.bounds.size.height
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.dripMerged.cgColor
        self.setImage(UIImage(named: "waterbottle.svg"), for: .normal)
        self.setTitle("", for: .normal)
        self.contentMode = .center
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.tintColor = .dripMerged
    }

}

//
//  DrinkTableViewCell.swift
//  Drip
//
//  Created by Kaiman Mehmet on 17/02/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit

protocol DrinkTableViewCellDelegate: AnyObject {
    func didTapButton(_ sender: UIButton)
}

class DrinkTableViewCell: UITableViewCell {

    weak var delegate: DrinkTableViewCellDelegate?

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .black
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .infoPanelBG
        volumeLabel.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        volumeLabel.textColor = .dripMerged
//        drinkLabel.font = UIFont.SFProRounded(ofSize: 25, fontWeight: .medium)
//        drinkLabel.textColor = UIColor.white.withAlphaComponent(0.87)
        imageViewContainer.backgroundColor = .clear
        drinkImageView.contentMode = .scaleAspectFit

        // Create Gradient Layer
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = imageViewContainer.bounds
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: "004997").cgColor,
                                UIColor.dripSecondary.cgColor]

        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        imageViewContainer.layer.insertSublayer(gradientLayer, at: 0)

        // Create Mask for Gradient Layer
        let maskPath = UIBezierPath(roundedRect: imageViewContainer.bounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: imageViewContainer.frame.height/2,
                                                        height: imageViewContainer.frame.height/2))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = imageViewContainer.bounds
        maskLayer.path = maskPath.cgPath

        gradientLayer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    override func layoutSubviews() {
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.height/2
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }

}

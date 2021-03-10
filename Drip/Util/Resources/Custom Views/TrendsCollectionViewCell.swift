//
//  TrendsCollectionViewCell.swift
//  Drip
//
//  Created by Kaiman Mehmet on 10/03/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit

class TrendsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trendLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var trendValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .infoPanelBG

        imageViewContainer.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit

        // Create Gradient Layer
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = imageViewContainer.bounds
        gradientLayer.colors = [UIColor.hexStringToUIColor(hex: "004997").cgColor,
                                UIColor.black.cgColor]

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

        trendLabel.textColor = UIColor.init(named: "whiteText")

        trendValueLabel.font = UIFont.SFProRounded(ofSize: 18, fontWeight: .medium)
        trendValueLabel.textColor = .dripMerged
    }


}

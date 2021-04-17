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

        imageViewContainer.backgroundColor = .infoPanelLight
        imageView.contentMode = .scaleAspectFit

        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.height / 2

        trendLabel.textColor = UIColor.init(named: "whiteText")

        trendValueLabel.font = UIFont.SFProRounded(ofSize: 18, fontWeight: .semibold)
        trendValueLabel.textColor = .dripMerged
        trendValueLabel.adjustsFontSizeToFitWidth = true
    }
}

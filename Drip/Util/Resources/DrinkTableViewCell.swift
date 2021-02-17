//
//  DrinkTableViewCell.swift
//  Drip
//
//  Created by Kaiman Mehmet on 17/02/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .black
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .infoPanelBG
        volumeLabel.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        volumeLabel.textColor = .dripMerged
        drinkLabel.font = UIFont.SFProRounded(ofSize: 25, fontWeight: .medium)
        drinkLabel.textColor = UIColor.white.withAlphaComponent(0.87)
        imageViewContainer.backgroundColor = .clear
        imageViewContainer.layer.borderWidth = 3
        imageViewContainer.layer.borderColor = UIColor.dripMerged.cgColor
        drinkImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.height/2
    }

}

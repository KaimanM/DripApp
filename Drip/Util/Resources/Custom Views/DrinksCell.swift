//
//  DrinksCell.swift
//  DummyCollection
//
//  Created by Kaiman Mehmet on 19/03/2021.
//

import UIKit

class DrinksCell: UICollectionViewCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Drink"
        label.textAlignment = .center
        return label
    }()

    let imageContainerView = UIView()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coffee.svg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(nameLabel)
        contentView.addSubview(imageContainerView)

        nameLabel.anchor(top: nil, leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         padding: .zero, size: .init(width: 0, height: 20))

        imageContainerView.backgroundColor = .green
        imageContainerView.anchor(top: contentView.topAnchor,
                                  leading: contentView.leadingAnchor,
                                  bottom: nameLabel.topAnchor,
                                  trailing: contentView.trailingAnchor,
                                  padding: .init(top: 10, left: 10, bottom: 5, right: 10))
        imageContainerView.layer.cornerRadius = 10

        imageContainerView.addSubview(imageView)
        imageView.anchor(top: imageContainerView.topAnchor,
                         leading: imageContainerView.leadingAnchor,
                         bottom: imageContainerView.bottomAnchor,
                         trailing: imageContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

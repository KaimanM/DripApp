//
//  AwardsDetailView.swift
//  Drip
//
//  Created by Kaiman Mehmet on 05/04/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit
import ConfettiView

final class AwardsDetailView: UIViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locked.svg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let awardNameLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .whiteText
        return label
    }()

    let awardBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "???"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()

    let confettiView = ConfettiView()

    var dataSource: AwardsDetailDataSourceProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.largeTitleDisplayMode = .never

        let subViews = [imageView, awardNameLabel, awardBodyLabel, confettiView]
        subViews.forEach({ view.addSubview($0) })

        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         padding: .init(top: 30, left: 0, bottom: 0, right: 0),
                         size: .init(width: 200, height: 200))
        imageView.centerHorizontallyInSuperview()

        awardNameLabel.anchor(top: imageView.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 15, left: 20, bottom: 0, right: 20))

        awardBodyLabel.anchor(top: awardNameLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 5, left: 20, bottom: 0, right: 20))

        confettiView.fillSuperViewSafely()

        confettiView.emit(with: [
            .shape(.circle, .dripPrimary),
            .shape(.triangle, .dripSecondary)
        ],
        for: 2.0)

        populateData()
    }

    func populateData() {
        guard let dataSource = dataSource else { return }
        imageView.image = UIImage(named: dataSource.imageName)
        awardNameLabel.text = dataSource.awardName
        awardBodyLabel.text = dataSource.awardBody
    }

}

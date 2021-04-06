//
//  AwardsDetailView.swift
//  Drip
//
//  Created by Kaiman Mehmet on 05/04/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit
import SwiftConfettiView

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

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()

    var dataSource: AwardsDetailDataSourceProtocol?

    var timeStamp: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.largeTitleDisplayMode = .never

        let confettiView = SwiftConfettiView(frame: self.view.bounds)

        let subViews = [imageView, awardNameLabel, awardBodyLabel, timeStampLabel, confettiView]
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
        timeStampLabel.anchor(top: awardBodyLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 5, left: 20, bottom: 0, right: 20))

        if let timeStamp = timeStamp {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            timeStampLabel.text = "Unlocked on \(formatter.string(from: timeStamp))"

            confettiView.intensity = 1
            confettiView.startConfetti()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                confettiView.stopConfetti()
            }
        }

        populateData()
    }

    func populateData() {
        guard let dataSource = dataSource else { return }
        imageView.image = UIImage(named: dataSource.imageName)
        awardNameLabel.text = dataSource.awardName
        awardBodyLabel.text = dataSource.awardBody
    }

}

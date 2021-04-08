import UIKit
import SwiftConfettiView

final class AwardsDetailView: UIViewController, AwardsDetailViewProtocol {

    var presenter: AwardsDetailPresenterProtocol!

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "isLocked.pdf")
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

    let confettiView = SwiftConfettiView()

    var dataSource: AwardsDetailDataSourceProtocol?

    var timeStamp: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationItem.largeTitleDisplayMode = .never
        presenter.onViewDidLoad()
        setupSubviews()
        animateConfetti()
    }

    func setupSubviews() {
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
        confettiView.fillSuperView()
    }

    func animateConfetti() {
        if timeStamp != nil {
            confettiView.intensity = 1
            confettiView.startConfetti()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.confettiView.stopConfetti()
            }
        }
    }

    func updateLabels(awardName: String, awardBody: String, timeStamp: String) {
        awardNameLabel.text = awardName
        awardBodyLabel.text = awardBody
        timeStampLabel.text = timeStamp
    }

    func updateImage(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }

}

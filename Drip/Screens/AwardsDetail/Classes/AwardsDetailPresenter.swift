import Foundation

final class AwardsDetailPresenter: AwardsDetailPresenterProtocol {
    weak private(set) var view: AwardsDetailViewProtocol?

    init(view: AwardsDetailViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        if let dataSource = view?.dataSource {

            var timeStampText = ""

            if let timeStamp = view?.timeStamp {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                timeStampText = "Unlocked on \(formatter.string(from: timeStamp))"
            }

            view?.updateLabels(awardName: dataSource.awardName,
                               awardBody: dataSource.awardBody,
                               timeStamp: timeStampText)
            view?.updateImage(imageName: dataSource.imageName)
        }
    }
}

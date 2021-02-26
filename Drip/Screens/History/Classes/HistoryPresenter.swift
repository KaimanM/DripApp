import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {
    weak private(set) var view: HistoryViewProtocol?
    var drinkArray: [DrinkEntry] = []

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "History")
        view?.setupCalendar()
        view?.setupInfoPanel()
    }

    // Not used because there is an issue with this firing before viewwilldisappear of previous vc
    func onViewWillAppear() {}

    func onViewDidAppear() {
        if let dataModel = view?.dataModel {
            drinkArray = dataModel.drinks
            print(drinkArray)
        }
    }

    func numberOfRowsInSection() -> Int {
        return drinkArray.count
    }

    func cellForRowAt(cell: DrinkTableViewCell, row: Int) -> DrinkTableViewCell {
        cell.drinkLabel.text = drinkArray[row].drinkName
        cell.volumeLabel.text = "\(Int(drinkArray[row].drinkVolume))ml"
        cell.drinkImageView?.image = UIImage(named: drinkArray[row].imageName)?
            .withTintColor(UIColor.white.withAlphaComponent(0.5))
            .withAlignmentRectInsets(UIEdgeInsets(top: -15,
                                                  left: -15,
                                                  bottom: -15,
                                                  right: -15))
        let calObject = Calendar.current
        let hour = calObject.component(.hour, from: drinkArray[row].timeStamp)
        let minutes = calObject.component(.minute, from: drinkArray[row].timeStamp)
        cell.timeStampLabel.text = "At \(hour):\(minutes)"
        return cell
    }

}

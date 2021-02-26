import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {

    weak private(set) var view: HistoryViewProtocol?
    var drinkArray: [DrinkEntry] = []
    var selectedDayDrinks: [DrinkEntry] = []
    var selectedDate = Date()

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
//        print("Presenter onViewDidLoad firing correctly")
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

        didSelectDate(date: selectedDate)
    }

    func didSelectDate(date: Date) {
        selectedDayDrinks = []
        var total: Double = 0
        let goal: Double = 2000
        for drink in drinkArray {
            if Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                total += drink.drinkVolume
                selectedDayDrinks.append(drink)
            }
        }
        view?.updateRingView(progress: CGFloat(total/goal), date: date, total: total, goal: goal)
        selectedDate = date
    }

    func cellForDate(cell: CustomFSCell, date: Date) -> CustomFSCell {
        var total: Double = 0
        let goal: Double = 2000
        for drink in drinkArray {
            if Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                total += drink.drinkVolume
            }
        }
        cell.ringView.setProgress(CGFloat(total/goal), duration: 0.5)
        return cell
    }

    func numberOfRowsInSection() -> Int {
        return selectedDayDrinks.count
    }

    func cellForRowAt(cell: DrinkTableViewCell, row: Int) -> DrinkTableViewCell {
        cell.drinkLabel.text = selectedDayDrinks[row].drinkName
        cell.volumeLabel.text = "\(Int(selectedDayDrinks[row].drinkVolume))ml"
        cell.drinkImageView?.image = UIImage(named: selectedDayDrinks[row].imageName)?
            .withTintColor(UIColor.white.withAlphaComponent(0.5))
            .withAlignmentRectInsets(UIEdgeInsets(top: -15,
                                                  left: -15,
                                                  bottom: -15,
                                                  right: -15))
        let calObject = Calendar.current
        let hour = calObject.component(.hour, from: selectedDayDrinks[row].timeStamp)
        let minutes = calObject.component(.minute, from: selectedDayDrinks[row].timeStamp)
        cell.timeStampLabel.text = "At \(hour):\(minutes)"
        return cell
    }

}

import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {

    weak private(set) var view: HistoryViewProtocol?
    var selectedDayDrinks: [Drink] = []
    var selectedDate = Date()
    var editingMode = false

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
//        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "History")
        view?.updateEditButton(title: "Toggle Edit")
        view?.setupCalendar()
        view?.setupInfoPanel()
    }

    // Not used because there is an issue with this firing before viewwilldisappear of previous vc
    func onViewWillAppear() {}

    func onViewDidAppear() {
        view?.coreDataController.fetchDrinks()
        print(view?.coreDataController.allEntries as Any)

        didSelectDate(date: selectedDate)
    }

    func didSelectDate(date: Date) {
        selectedDate = date
        populateDrinks()
    }

    func populateDrinks() {
        selectedDayDrinks = []
        var total: Double = 0
        let goal: Double = 2000

        for drink in view?.coreDataController?.fetchEntriesForDate(date: selectedDate) ?? [] {
                total += drink.volume
                selectedDayDrinks.append(drink)
        }

        view?.updateRingView(progress: CGFloat(total/goal), date: selectedDate, total: total, goal: goal)
    }

    func editToggleTapped() {
        if editingMode == true {
            editingMode = false
        } else {
            editingMode = true
        }
        let buttonTitle = !editingMode ? "Toggle Edit" : "Finished"
        view?.updateEditButton(title: buttonTitle)
        view?.refreshUI()
    }

    func isHidingEditButton() -> Bool {
        return !editingMode
    }

    func cellForDate(cell: CustomFSCell, date: Date) -> CustomFSCell {
        var total: Double = 0
        let goal: Double = 2000

        for drink in view?.coreDataController?.fetchEntriesForDate(date: date) ?? [] {
                total += drink.volume
        }

        cell.ringView.setProgress(CGFloat(total/goal), duration: 0.5)
        return cell
    }

    func numberOfRowsInSection() -> Int {
        return selectedDayDrinks.count
    }

    func cellForRowAt(cell: DrinkTableViewCell, row: Int) -> DrinkTableViewCell {
        cell.drinkLabel.text = selectedDayDrinks[row].name
        cell.volumeLabel.text = "\(Int(selectedDayDrinks[row].volume))ml"
        cell.drinkImageView?.image = UIImage(named: selectedDayDrinks[row].imageName)?
            .withTintColor(UIColor.white.withAlphaComponent(0.5))
            .withAlignmentRectInsets(UIEdgeInsets(top: -15,
                                                  left: -15,
                                                  bottom: -15,
                                                  right: -15))
        cell.deleteButton.tag = row
        let calObject = Calendar.current
        let hour = calObject.component(.hour, from: selectedDayDrinks[row].timeStamp)
        let minutes = calObject.component(.minute, from: selectedDayDrinks[row].timeStamp)
        cell.timeStampLabel.text = "At \(hour):\(minutes)"
        return cell
    }

    func didTapDeleteButton(row: Int) {
        let confirmDeleteAlert = UIAlertController(title: "Delete Entry?",
                                                   message:"Are you sure you want to delete this entry?",
                                                   preferredStyle: .alert)

        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {_ in
            self.view?.coreDataController.deleteEntry(entry: self.selectedDayDrinks[row])
            self.populateDrinks()
            self.view?.refreshUI()
        }))

        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        view?.presentView(confirmDeleteAlert)
    }

}

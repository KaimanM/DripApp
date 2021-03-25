import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {

    weak private(set) var view: HistoryViewProtocol?
    var selectedDayDrinks: [Drink] = []
    var selectedDate = Date()
    var editingMode = false

    var goal: Double {
        return (view?.userDefaultsController.drinkGoal)!
    }

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "History")
        view?.updateEditButton(title: "Toggle Edit")
        view?.setupCalendar()
        view?.setupInfoPanel()
    }

    // Not used because there is an issue with this firing before viewwilldisappear of previous vc
    func onViewWillAppear() {}

    func onViewDidAppear() {
        view?.coreDataController.fetchDrinks()

        didSelectDate(date: selectedDate)
    }

    func didSelectDate(date: Date) {
        selectedDate = date
        populateDrinks()
    }

    func populateDrinks() {
        selectedDayDrinks = []
        var total: Double = 0
//        let goal: Double = 2000

        for drink in view?.coreDataController?.fetchEntriesForDate(date: selectedDate)
            .sorted(by: { $0.timeStamp < $1.timeStamp}) ?? [] {
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

    func cellForDate(date: Date) -> Double {
        var total: Double = 0
//        let goal: Double = 2000

        for drink in view?.coreDataController?.fetchEntriesForDate(date: date) ?? [] {
                total += drink.volume
        }
        return total/goal
    }

    func numberOfRowsInSection() -> Int {
        return selectedDayDrinks.count
    }

    //swiftlint:disable:next large_tuple
    func cellForRowAt(row: Int) -> (name: String, volume: String, imageName: String, timeStampTitle: String) {
        let calObject = Calendar.current
        let hour = calObject.component(.hour, from: selectedDayDrinks[row].timeStamp)
        let hoursString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minutes = calObject.component(.minute, from: selectedDayDrinks[row].timeStamp)
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let volumeLabel = "\(Int(selectedDayDrinks[row].volume))ml"
        return (name: selectedDayDrinks[row].name,
                volume: volumeLabel,
                imageName: selectedDayDrinks[row].imageName,
                timeStampTitle: "At \(hoursString):\(minutesString)")
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

    func addDrinkTapped(drinkName: String, volume: Double, imageName: String) {
        view?.coreDataController.addDrink(name: drinkName,
                                          volume: volume,
                                          imageName: imageName,
                                          timeStamp: selectedDate)
        populateDrinks()
        view?.refreshUI()
    }
}

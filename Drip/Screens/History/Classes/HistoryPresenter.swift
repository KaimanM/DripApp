import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {

    weak private(set) var view: HistoryViewProtocol?
    var selectedDayDrinks: [Drink] = []
    var selectedDate = Date()
    var selectedDay: Day?
    var editingMode = false

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
        selectedDay = view?.coreDataController.getDayForDate(date: date)
        populateDrinks()
    }

    func populateDrinks() {
        selectedDayDrinks = []
        var total: Double = 0
        var goal2: Double = (view?.userDefaultsController.drinkGoal)!

        if let selectedDay = selectedDay {
            total = selectedDay.total
            goal2 = selectedDay.goal
        }

        if let drinks = (selectedDay?.drinks?.allObjects as? [Drink])?
            .sorted(by: { $0.timeStamp < $1.timeStamp}) {
            for drink in drinks {
                selectedDayDrinks.append(drink)
            }
        }

        view?.updateRingView(progress: CGFloat(total/goal2), date: selectedDate, total: total, goal: goal2)
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
        var progress: Double = 0
        // can be quite expensive
        if let selectedDay = view?.coreDataController.getDayForDate(date: date) {
            progress = selectedDay.total/selectedDay.goal
        }

        return progress
    }

    func numberOfRowsInSection() -> Int {
        if let selectedDayDrinks = selectedDay?.drinks {
            return selectedDayDrinks.count
        } else {
            return 0
        }
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
            self.selectedDay = self.view?.coreDataController.getDayForDate(date: self.selectedDate)
            self.populateDrinks()
            self.view?.refreshUI()
        }))

        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        view?.presentView(confirmDeleteAlert)
    }

    func addDrinkTapped(drinkName: String, volume: Double, imageName: String) {
        view?.coreDataController.addDrinkForDay(name: drinkName,
                                                volume: volume,
                                                imageName: imageName,
                                                timeStamp: selectedDate)
        if selectedDay == nil {
            selectedDay = view?.coreDataController.getDayForDate(date: selectedDate)
        }
        populateDrinks()
        view?.refreshUI()
    }
}

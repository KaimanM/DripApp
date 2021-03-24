import UIKit

final class HistoryPresenter: HistoryPresenterProtocol {

    weak private(set) var view: HistoryViewProtocol?
    var selectedDayDrinks: [Drink] = []
    var selectedDate = Date()
    var editingMode = false
    let defaults = UserDefaults.standard
    var goal: Double {
        return defaults.double(forKey: "goal") == 0 ? 2000 : defaults.double(forKey: "goal")
    }

    let drinkNames = ["Water", "Coffee", "Tea", "Milk", "Orange Juice", "Juicebox",
                      "Cola", "Cocktail", "Punch", "Milkshake", "Energy Drink", "Beer"] // icetea

    let drinkImageNames = ["waterbottle.svg", "coffee.svg", "tea.svg", "milk.svg", "orangejuice.svg",
                            "juicebox.svg", "cola.svg", "cocktail.svg", "punch.svg", "milkshake.svg",
                            "energydrink.svg", "beer.svg"]

    // TODO: Change to vars and creare userdefaults method to retrieve these.
    let favNames = ["Water", "Coffee", "Punch", "Milk"]
    let favImageNames = ["waterbottle.svg", "coffee.svg", "punch.svg", "milk.svg"]
    let favVolumeTitles: [Double] = [250, 350, 400, 500]

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
        let minutes = calObject.component(.minute, from: selectedDayDrinks[row].timeStamp)
        let volumeLabel = "\(Int(selectedDayDrinks[row].volume))ml"
        return (name: selectedDayDrinks[row].name,
                volume: volumeLabel,
                imageName: selectedDayDrinks[row].imageName,
                timeStampTitle: "At \(hour):\(minutes)")
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

    func getDrinkInfo() -> (drinkNames: [String], drinkImageNames: [String]) {
        return (drinkNames, drinkImageNames)
    }

    func getFavoritesInfo() -> (volumeTitle: [Double], drinkImageNames: [String]) {
        return (favVolumeTitles, favImageNames)
    }

    func quickDrinkAtIndexTapped(index: Int) {
        addDrinkTapped(drinkName: favNames[index],
                       volume: favVolumeTitles[index],
                       imageName: drinkImageNames[index])
    }

}

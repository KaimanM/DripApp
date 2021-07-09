import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?

    var todaysTotal: Double {
        if let today = today {
            return today.total
        } else {
            return 0
        }
    }

    var today: Day?

    var drinkGoal: Double {
        return (view?.userDefaultsController.drinkGoal)!
    }

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        // Sets today object as day object for todays date if exists else sets nil.
        today = view?.coreDataController.getDayForDate(date: Date())

        updateProgressRing()
        updateGradientBars()
        updateOverviewTitles()
    }

    func onViewWillAppear() {
        updateGreetingLabel(date: Date())
    }

    func onViewWillDisappear() {
        if let coreDataController = view?.coreDataController {
            coreDataController.saveContext()
        }
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Today")
        view?.setupRingView(startColor: .cyan, endColor: .blue, ringWidth: 30)
        view?.setupGradientBars(dailyGoal: Int(drinkGoal),
                                morningGoal: Int(drinkGoal/3),
                                afternoonGoal: Int(drinkGoal/3),
                                eveningGoal: Int(drinkGoal/3))

    }

    func updateGreetingLabel(date: Date) {
        guard let name = view?.userDefaultsController.name else { return }

        var greeting: String
        switch Calendar.current.component(.hour, from: date) {
        case 0...11:
            greeting = "Good Morning, \(name)"
        case 12...17:
            greeting = "Good Afternoon, \(name)"
        case 18...24:
            greeting = "Good Evening, \(name)"
        default:
            greeting = "Hello, \(name)"
        }

        view?.updateGreetingLabel(text: greeting)
    }

    func updateProgressRing() {
        let progress = todaysTotal/drinkGoal
        view?.setRingProgress(progress: progress)
        view?.animateLabel(endValue: progress*100, animationDuration: 2)
    }

    func updateGradientBars() {
        var morningTotal: Double = 0
        var afternoonTotal: Double = 0
        var eveningTotal: Double = 0

        if let drinks = today?.drinks?.allObjects as? [Drink] {
            for drink in drinks {
                switch Calendar.current.component(.hour, from: drink.timeStamp) {
                case 0...11:
                    morningTotal += drink.volume
                case 12...17:
                    afternoonTotal += drink.volume
                case 18...24:
                    eveningTotal += drink.volume
                default:
                    break
                }
            }
        }

        view?.setTodayGradientBarProgress(total: todaysTotal, goal: drinkGoal)
        view?.setMorningGradientBarProgress(total: morningTotal, goal: drinkGoal/3)
        view?.setAfternoonGradientBarProgress(total: afternoonTotal, goal: drinkGoal/3)
        view?.setEveningGradientBarProgress(total: eveningTotal, goal: drinkGoal/3)

    }

    func addDrinkTapped(beverage: Beverage, volume: Double) {
        let timeStamp = Date()

        view?.coreDataController.addDrinkForDay(beverage: beverage,
                                                volume: volume,
                                                timeStamp: timeStamp)

        if today == nil {
            today = view?.coreDataController.getDayForDate(date: timeStamp)
        }

        if let userDefaultsController = view?.userDefaultsController,
           userDefaultsController.enabledHealthKit {
            view?.healthKitController.addWaterDataToHealthStore(amount: volume, date: timeStamp)
        }

        updateProgressRing()
        updateGradientBars()
        updateOverviewTitles()

    }

    func updateOverviewTitles() {
        let remaining = Int(drinkGoal-todaysTotal) < 0 ? 0 : Int(drinkGoal-todaysTotal)
        view?.setOverviewTitles(remainingText: "\(Int(remaining))ml", goalText: "\(Int(drinkGoal))ml")
    }
}

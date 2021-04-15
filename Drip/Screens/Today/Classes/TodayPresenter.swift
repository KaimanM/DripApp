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

        // delete this soon
//        let drinks = view?.coreDataController.getDrinksForDate(date: Date())
//        for drink in drinks! {
//            print(drink.name)
//        }
    }

    func onViewWillAppear() {
        updateGreetingLabel()
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

    func updateGreetingLabel() {
        let name = (view?.userDefaultsController.name)!
        view?.updateGreetingLabel(text: "Good morning, \(name)")
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
                case 0...12:
                    morningTotal += drink.volume
                case 12...18:
                    afternoonTotal += drink.volume
                case 18...24:
                    eveningTotal += drink.volume
                default:
                    fatalError("time out of bounds")
                }
            }
        }

        view?.setTodayGradientBarProgress(total: todaysTotal, goal: drinkGoal)
        view?.setMorningGradientBarProgress(total: morningTotal, goal: drinkGoal/3)
        view?.setAfternoonGradientBarProgress(total: afternoonTotal, goal: drinkGoal/3)
        view?.setEveningGradientBarProgress(total: eveningTotal, goal: drinkGoal/3)

    }

    func addDrinkTapped(beverage: Beverage, volume: Double) {
        view?.coreDataController.addDrinkForDay(beverage: beverage,
                                                volume: volume,
                                                timeStamp: Date())

        if today == nil {
            today = view?.coreDataController.getDayForDate(date: Date())
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

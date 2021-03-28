import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?
    var todaysTotal: Double = 0

    var drinkGoal: Double {
        return (view?.userDefaultsController.drinkGoal)!
    }

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        updateProgressRing()
        updateGradientBars()
        updateButtonTitles()
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
//        loadGoal()
        view?.setupRingView(startColor: .cyan, endColor: .blue, ringWidth: 30)
        view?.setupGradientBars(dailyGoal: Int(drinkGoal),
                                morningGoal: Int(drinkGoal/3),
                                afternoonGoal: Int(drinkGoal/3),
                                eveningGoal: Int(drinkGoal/3))

    }

//    func loadGoal() {
//        drinkGoal = defaults.double(forKey: "goal") == 0 ? 2000 : defaults.double(forKey: "goal")
//    }

    func updateGreetingLabel() {
        let name = (view?.userDefaultsController.name)!
        view?.updateGreetingLabel(text: "Good morning, \(name)")
    }

    func updateProgressRing() {
        todaysTotal = 0
        for drink in view?.coreDataController?.fetchEntriesForDate(date: Date()) ?? [] {
                todaysTotal += drink.volume
        }
        let progress = todaysTotal/drinkGoal
        view?.setRingProgress(progress: progress)
        view?.animateLabel(endValue: progress*100, animationDuration: 2)
    }

    func updateGradientBars() {
        var morningTotal: Double = 0
        var afternoonTotal: Double = 0
        var eveningTotal: Double = 0

        for drink in view?.coreDataController.fetchEntriesForDate(date: Date()) ?? [] {
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

        view?.setTodayGradientBarProgress(total: todaysTotal, goal: drinkGoal)
        view?.setMorningGradientBarProgress(total: morningTotal, goal: drinkGoal/3)
        view?.setAfternoonGradientBarProgress(total: afternoonTotal, goal: drinkGoal/3)
        view?.setEveningGradientBarProgress(total: eveningTotal, goal: drinkGoal/3)

    }

    func updateGoal(goal: Double) {
        view?.userDefaultsController.drinkGoal = goal
        print(goal)
        updateProgressRing()
        updateGradientBars()
        updateButtonTitles()
    }

    func addDrinkTapped(drinkName: String, volume: Double, imageName: String) {
        todaysTotal += volume
        view?.coreDataController.addDrink(name: drinkName, volume: volume, imageName: imageName, timeStamp: Date())
        updateProgressRing()
        updateGradientBars()
        updateButtonTitles()

    }

    func updateButtonTitles() {
        let remaining = Int(drinkGoal-todaysTotal) < 0 ? 0 : Int(drinkGoal-todaysTotal)
        view?.setButtonTitles(remainingText: "\(Int(remaining))ml", goalText: "\(Int(drinkGoal))ml")
    }
}

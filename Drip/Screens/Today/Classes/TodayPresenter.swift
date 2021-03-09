import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?
    var todaysTotal: Double = 0
    let drinkGoal: Double = 2000

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        updateProgressRing()
        updateGradientBars()
    }

    func onViewWillAppear() {}

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
        view?.updateButtonImages(image1Name: "waterbottle.svg",
                                 image2Name: "coffee.svg",
                                 image3Name: "cola.svg",
                                 image4Name: "add.svg")
        view?.updateButtonSubtitles(subtitle1: "Water",
                                    subtitle2: "Coffee",
                                    subtitle3: "Soda",
                                    subtitle4: "Custom")
    }

    func onDrinkButton1Tapped() {
        todaysTotal += 500
        view?.coreDataController.addDrink(name: "Water", volume: 500, imageName: "waterbottle.svg", timeStamp: Date())
        updateProgressRing()
        updateGradientBars()
    }

    func onDrinkButton2Tapped() {
        todaysTotal += 500
        view?.coreDataController.addDrink(name: "Coffee", volume: 250, imageName: "coffee.svg", timeStamp: Date())
        updateProgressRing()
        updateGradientBars()
    }

    func onDrinkButton3Tapped() {
        todaysTotal += 500
        view?.coreDataController.addDrink(name: "Cola", volume: 330, imageName: "cola.svg", timeStamp: Date())
        updateProgressRing()
        updateGradientBars()
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

}

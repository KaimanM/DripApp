import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?
    var todaysTotal: Double = 0
    let drinkGoal: Double = 2000
    var todaysDrinks: [DrinkEntry] = []

    var button1Drink = DrinkEntry(drinkName: "Water",
                                  drinkVolume: 500,
                                  imageName: "waterbottle.svg",
                                  timeStamp: Date())

    var button2Drink = DrinkEntry(drinkName: "Coffee",
                                  drinkVolume: 250,
                                  imageName: "coffee.svg",
                                  timeStamp: Date())

    var button3Drink = DrinkEntry(drinkName: "cola",
                                  drinkVolume: 330,
                                  imageName: "cola.svg",
                                  timeStamp: Date())

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
        updateProgressRing()
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
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
        todaysTotal += button1Drink.drinkVolume
        todaysDrinks.append(button1Drink)
        updateProgressRing()
        updateGradientBars()
    }

    func onDrinkButton2Tapped() {
        todaysTotal += button2Drink.drinkVolume
        todaysDrinks.append(button2Drink)
        updateProgressRing()
        updateGradientBars()
    }

    func onDrinkButton3Tapped() {
        todaysTotal += button3Drink.drinkVolume
        todaysDrinks.append(button3Drink)
        updateProgressRing()
        updateGradientBars()
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

        for drink in todaysDrinks {
            switch Calendar.current.component(.hour, from: drink.timeStamp) {
            case 0...12:
                morningTotal += drink.drinkVolume
            case 12...18:
                afternoonTotal += drink.drinkVolume
            case 18...24:
                eveningTotal += drink.drinkVolume
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

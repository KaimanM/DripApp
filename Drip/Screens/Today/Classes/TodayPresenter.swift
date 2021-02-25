import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?
    var todaysTotal: Double = 0
    let drinkGoal: Double = 2000

    var button1Drink = DrinkEntry(drinkName: "Water",
                                  drinkVolume: 450,
                                  imageName: "waterbottle.svg",
                                  timeStamp: Date())

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
        updateProgressRing()
        saveDrink()
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

    func saveDrink() {
        let sip = Drink(timeStamp: Date(), volume: 250)
        print(Calendar.current.component(.hour, from: sip.timeStamp))
    }

    func onDrinkButton1Tapped() {
        todaysTotal += button1Drink.drinkVolume
        updateProgressRing()
        updateGradientBars()
    }

    func onDrinkButton2Tapped() {
        todaysTotal -= button1Drink.drinkVolume
        updateProgressRing()
        updateGradientBars()
    }

    func updateProgressRing() {
        print("this works")
        let progress = todaysTotal/drinkGoal
        view?.setRingProgress(progress: progress)
        view?.animateLabel(endValue: progress*100, animationDuration: 2)
    }

    func updateGradientBars() {
        view?.setTodayGradientBarProgress(total: todaysTotal, goal: drinkGoal)
        view?.setMorningGradientBarProgress(total: todaysTotal, goal: drinkGoal/3)
    }

}

struct Drink {
    let timeStamp: Date
    let volume: Double
}

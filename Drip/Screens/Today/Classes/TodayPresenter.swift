import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
//        view?.setRingProgress(progress: Double.random(in: 0...1))
        let progress = 0.85
        view?.setRingProgress(progress: progress)
        view?.animateLabel(endValue: progress*100, animationDuration: 2)
        saveDrink()
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Today")
        view?.setupRingView(startColor: .cyan, endColor: .blue, ringWidth: 30)
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
        let drink1Value = Double.random(in: 0...1)
        view?.setRingProgress(progress: drink1Value)
        view?.animateLabel(endValue: drink1Value*100, animationDuration: 2)
    }

}

struct Drink {
    let timeStamp: Date
    let volume: Double
}

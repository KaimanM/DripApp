import Foundation

final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
//        view?.setRingProgress(progress: Double.random(in: 0...1))
        view?.setRingProgress(progress: 0.74)
        saveDrink()
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Today")
        view?.setupRingView(startColor: .cyan, endColor: .blue, ringWidth: 30)
    }

    func saveDrink() {
        let sip = Drink(timeStamp: Date(), volume: 250)
        print(Calendar.current.component(.hour, from: sip.timeStamp))
    }

}

struct Drink {
    let timeStamp: Date
    let volume: Double
}

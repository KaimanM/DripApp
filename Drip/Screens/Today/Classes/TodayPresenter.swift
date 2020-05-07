final class TodayPresenter: TodayPresenterProtocol {
    weak private(set) var view: TodayViewProtocol?

    init(view: TodayViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
        view?.setRingProgress(progress: Double.random(in: 0...1))
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Today")
        view?.setupRingView(startColor: .cyan, endColor: .blue, ringWidth: 25)
    }

}

final class TrendsPresenter: TrendsPresenterProtocol {
    weak private(set) var view: TrendsViewProtocol?

    init(view: TrendsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Trends")
    }

}

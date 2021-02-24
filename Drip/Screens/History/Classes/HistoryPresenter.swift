final class HistoryPresenter: HistoryPresenterProtocol {
    weak private(set) var view: HistoryViewProtocol?

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "History")
        view?.setupCalendar()
        view?.setupInfoPanel()
    }

}

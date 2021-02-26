final class HistoryPresenter: HistoryPresenterProtocol {
    weak private(set) var view: HistoryViewProtocol?
    var drinkArray: [DrinkEntry] = []

    init(view: HistoryViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
        if let dataModel = view?.dataModel {
            drinkArray = dataModel.drinks
        }
        print(drinkArray)
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "History")
        view?.setupCalendar()
        view?.setupInfoPanel()
    }

}

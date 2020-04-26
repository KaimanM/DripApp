final class AwardsPresenter: AwardsPresenterProtocol {
    weak private(set) var view: AwardsViewProtocol?

    init(view: AwardsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Awards Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Awards Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Awards")
    }

}

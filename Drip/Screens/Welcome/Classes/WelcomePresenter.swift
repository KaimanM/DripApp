final class WelcomePresenter: WelcomePresenterProtocol {
    weak private(set) var view: WelcomeViewProtocol?

    init(view: WelcomeViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "tetssfsd")
    }

}

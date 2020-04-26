final class AboutPresenter: AboutPresenterProtocol {
    weak private(set) var view: AboutViewProtocol?

    init(view: AboutViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("About Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("About Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "About")
    }

}

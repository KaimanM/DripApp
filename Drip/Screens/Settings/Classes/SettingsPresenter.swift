final class SettingsPresenter: SettingsPresenterProtocol {
    weak private(set) var view: SettingsViewProtocol?

    init(view: SettingsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Settings Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Settings Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Settings")
    }

}

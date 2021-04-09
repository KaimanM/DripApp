protocol SettingsPresenterProtocol: class {
    var view: SettingsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

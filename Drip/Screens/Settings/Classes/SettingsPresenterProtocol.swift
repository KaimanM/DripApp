import Foundation

protocol SettingsPresenterProtocol: class {
    var view: SettingsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()

    func numberOfRowsInSection(_ section: Int) -> Int
    func getCellDataForIndexPath(indexPath: IndexPath) -> SettingsCellData
    func didSelectRowAt(indexPath: IndexPath)
    func fetchName() -> String
    func updateName(name: String?)
}

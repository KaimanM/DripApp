import Foundation

protocol SettingsDetailPresenterProtocol: class {
    var view: SettingsDetailViewProtocol? { get }
    func onViewDidLoad()

    func updateGoalValue(newGoal: Double)
    func saveButtonTapped()

    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double)
    func setSelectedFavourite(selected: Int)
    func addFavourite(name: String, volume: Double, imageName: String)

    func numberOfRowsInSection() -> Int
    func coefficientCellDataForRow(row: Int) -> Beverage
    func attributionTitleForRow(row: Int) -> String
    func getAttributionURLforRow(row: Int) -> URL?
    func creditAlertControllerForRow(row: Int)
}

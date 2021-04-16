import Foundation

protocol SettingsDetailPresenterProtocol: class {
    var view: SettingsDetailViewProtocol? { get }
    func onViewDidLoad()

    func updateGoalValue(newGoal: Double)
    func saveButtonTapped()

    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double)
    func setSelectedFavourite(selected: Int)
    func addFavourite(beverage: Beverage, volume: Double)

    func numberOfRowsInSection() -> Int
    func coefficientCellDataForRow(row: Int) -> Beverage
    func setCoefficientBool(isEnabled: Bool)
    func attributionTitleForRow(row: Int) -> String
    func getAttributionURLforRow(row: Int) -> URL?
    func creditAlertControllerForRow(row: Int)
}

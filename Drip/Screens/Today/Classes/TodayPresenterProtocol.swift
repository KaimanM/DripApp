protocol TodayPresenterProtocol: class {
    var view: TodayViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func updateGoal(goal: Double)
    func addDrinkTapped(beverage: Beverage, volume: Double)
}

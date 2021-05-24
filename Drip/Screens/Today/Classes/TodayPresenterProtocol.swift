protocol TodayPresenterProtocol: AnyObject {
    var view: TodayViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func addDrinkTapped(beverage: Beverage, volume: Double)
}

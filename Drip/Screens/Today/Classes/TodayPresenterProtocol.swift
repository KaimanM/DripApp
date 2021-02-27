protocol TodayPresenterProtocol: class {
    var view: TodayViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()

    func onDrinkButton1Tapped()
    func onDrinkButton2Tapped()
    func onDrinkButton3Tapped()
}

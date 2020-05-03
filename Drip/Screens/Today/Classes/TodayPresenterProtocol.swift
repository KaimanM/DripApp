protocol TodayPresenterProtocol: class {
    var view: TodayViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

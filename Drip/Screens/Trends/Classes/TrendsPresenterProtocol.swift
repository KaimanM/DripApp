protocol TrendsPresenterProtocol: class {
    var view: TrendsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

protocol HistoryPresenterProtocol: class {
    var view: HistoryViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

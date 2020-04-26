protocol AboutPresenterProtocol: class {
    var view: AboutViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

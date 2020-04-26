protocol AwardsPresenterProtocol: class {
    var view: AwardsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
}

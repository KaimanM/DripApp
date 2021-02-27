protocol TabBarPresenterProtocol: class {
    var view: TabBarViewProtocol? { get }

    func onViewDidLoad()
}

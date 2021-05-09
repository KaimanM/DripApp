protocol TabBarPresenterProtocol: AnyObject {
    var view: TabBarViewProtocol? { get }

    func onViewDidLoad()
}

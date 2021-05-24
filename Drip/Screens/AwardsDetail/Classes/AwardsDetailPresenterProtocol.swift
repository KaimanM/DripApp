protocol AwardsDetailPresenterProtocol: AnyObject {
    var view: AwardsDetailViewProtocol? { get }
    func onViewDidLoad()
}

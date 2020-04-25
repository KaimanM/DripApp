protocol WelcomePresenterProtocol: class {
    var view: WelcomeViewProtocol? { get }
    
    func onViewDidAppear()
    func onViewDidLoad()
}

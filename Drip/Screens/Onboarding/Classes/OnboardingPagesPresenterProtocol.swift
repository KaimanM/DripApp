protocol OnboardingPagesPresenterProtocol: class {
    var view: OnboardingPagesViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
}

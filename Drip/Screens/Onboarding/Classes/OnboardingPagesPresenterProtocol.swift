protocol OnboardingPagesPresenterProtocol: class {
    var view: OnboardingPagesViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double)
    func addFavourite(name: String, volume: Double, imageName: String)
    func setSelectedFavourite(selected: Int)
}

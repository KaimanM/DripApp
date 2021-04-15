protocol OnboardingPagesPresenterProtocol: class {
    var view: OnboardingPagesViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double)
    func addFavourite(beverage: Beverage, volume: Double)
    func setSelectedFavourite(selected: Int)
    func setNameAndGoal(name: String, goal: Double)
    func didCompleteOnboarding()
}

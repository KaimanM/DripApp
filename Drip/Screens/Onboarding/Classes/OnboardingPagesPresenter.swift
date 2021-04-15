import Foundation

final class OnboardingPagesPresenter: OnboardingPagesPresenterProtocol {
    weak private(set) var view: OnboardingPagesViewProtocol?

    var selectedFavourite = 0

    init(view: OnboardingPagesViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
    }

    func onViewDidLoad() {
    }

    func onViewWillAppear() {
    }

    func onViewWillDisappear() {
    }

    func setSelectedFavourite(selected: Int) {
        selectedFavourite = selected
    }

    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double) {
        var volume: Double
        var imageName: String

        guard let userDefaults = view?.userDefaultsController else { return ("waterbottle.svg", 100.0)}

        switch index {
        case 0:
            volume = userDefaults.favDrink1Volume
            imageName = userDefaults.favBeverage1.imageName
        case 1:
            volume = userDefaults.favDrink2Volume
            imageName = userDefaults.favBeverage2.imageName
        case 2:
            volume = userDefaults.favDrink3Volume
            imageName = userDefaults.favBeverage3.imageName
        case 3:
            volume = userDefaults.favDrink4Volume
            imageName = userDefaults.favBeverage4.imageName
        default:
            volume = userDefaults.favDrink1Volume
            imageName = userDefaults.favBeverage1.imageName
        }

        return (imageName, volume)

    }

    func addFavourite(beverage: Beverage, volume: Double) {
        guard let userDefaults = view?.userDefaultsController else { return }

        switch selectedFavourite {
        case 0:
            userDefaults.favBeverage1 = beverage
            userDefaults.favDrink1Volume = volume
        case 1:
            userDefaults.favBeverage2 = beverage
            userDefaults.favDrink2Volume = volume
        case 2:
            userDefaults.favBeverage3 = beverage
            userDefaults.favDrink3Volume = volume
        case 3:
            userDefaults.favBeverage4 = beverage
            userDefaults.favDrink4Volume = volume
        default:
            break
        }
    }

    func setNameAndGoal(name: String, goal: Double) {
        guard let userDefaults = view?.userDefaultsController else { return }
        userDefaults.name = name
        userDefaults.drinkGoal = goal
    }

    func didCompleteOnboarding() {
        guard let userDefaults = view?.userDefaultsController else { return }
        userDefaults.completedOnboarding = true
    }
}

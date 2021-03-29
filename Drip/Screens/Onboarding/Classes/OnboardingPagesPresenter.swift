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
            imageName = userDefaults.favDrink1ImageName
        case 1:
            volume = userDefaults.favDrink2Volume
            imageName = userDefaults.favDrink2ImageName
        case 2:
            volume = userDefaults.favDrink3Volume
            imageName = userDefaults.favDrink3ImageName
        case 3:
            volume = userDefaults.favDrink4Volume
            imageName = userDefaults.favDrink4ImageName
        default:
            volume = userDefaults.favDrink1Volume
            imageName = userDefaults.favDrink1ImageName
        }

        return (imageName, volume)

    }

    func addFavourite(name: String, volume: Double, imageName: String) {
        guard let userDefaults = view?.userDefaultsController else { return }

        switch selectedFavourite {
        case 0:
            userDefaults.favDrink1Name = name
            userDefaults.favDrink1Volume = volume
            userDefaults.favDrink1ImageName = imageName
        case 1:
            userDefaults.favDrink2Name = name
            userDefaults.favDrink2Volume = volume
            userDefaults.favDrink2ImageName = imageName
        case 2:
            userDefaults.favDrink3Name = name
            userDefaults.favDrink3Volume = volume
            userDefaults.favDrink3ImageName = imageName
        case 3:
            userDefaults.favDrink4Name = name
            userDefaults.favDrink4Volume = volume
            userDefaults.favDrink4ImageName = imageName
        default:
            break
        }
    }
}

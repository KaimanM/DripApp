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
        setCurrentVersion()
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

    func setCurrentVersion() {
        guard let userDefaults = view?.userDefaultsController else { return }
        userDefaults.currentVersion = Bundle.main.appVersion
        print("setting current app verision")
    }

    func didCompleteOnboarding() {
        guard let userDefaults = view?.userDefaultsController else { return }
        userDefaults.completedOnboarding = true
        view?.notificationController.checkAuthStatus(completion: { status in
            if status == .authorized || status == .provisional {
                self.view?.notificationController.schedule(completion: nil)
            }
        })
    }

    func onSwitchToggle(isOn: Bool) {
        switch isOn {
        case true:
            view?.notificationController.checkAuthStatus(completion: { status in
                    switch status {
                    case .authorized, .provisional:
                        self.view?.notificationController.setupDefaultNotifications()
                        self.view?.setToggleStatus(isOn: true)
                        self.view?.userDefaultsController.enabledNotifications = true
                    case .notDetermined:
                        self.view?.notificationController.requestAuth(completion: { granted in
                            switch granted {
                            case true:
                                self.view?.notificationController.setupDefaultNotifications()
                                self.view?.setToggleStatus(isOn: true)
                                self.view?.userDefaultsController.enabledNotifications = true
                            case false:
                                self.view?.showSettingsNotificationDialogue()
                                self.view?.setToggleStatus(isOn: false)
                                self.view?.userDefaultsController.enabledNotifications = false
                            }
                        })
                    default:
                        self.view?.showSettingsNotificationDialogue()
                        self.view?.setToggleStatus(isOn: false)
                        self.view?.userDefaultsController.enabledNotifications = false
                    }
            })
        case false:
            view?.notificationController.removeAllPendingNotifications()
            view?.setToggleStatus(isOn: false)
            self.view?.userDefaultsController.enabledNotifications = false
        }
    }
}

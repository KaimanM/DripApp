import Foundation

class SettingsDetailPresenter: SettingsDetailPresenterProtocol {
    var view: SettingsDetailViewProtocol?

    var goalValue: Double = 2000
    var selectedFavourite = 0

    struct AttributionCellData {
        let title: String
        let url: URL?
    }

    let attributeCells: [AttributionCellData] = [
        AttributionCellData(title: "FSCalendar",
                       url: URL(string: "https://github.com/WenchaoD/FSCalendar")!),
        AttributionCellData(title: "Swift Confetti View",
                       url: URL(string: "https://github.com/ugurethemaydin/SwiftConfettiView")!),
        AttributionCellData(title: "FreePik - Beverages Icon Pack",
                       url: URL(string: "https://www.freepik.com/")!),
        AttributionCellData(title: "FreePik - Education Icon Pack",
                       url: URL(string: "https://www.freepik.com/")!),
        AttributionCellData(title: "Flat Icon",
                       url: URL(string: "https://www.flaticon.com/")!),
        AttributionCellData(title: "Mike Bone",
                       url: URL(string: "https://github.com/mikecbone")!),
        AttributionCellData(title: "Marian Butnaru",
                       url: nil)
        ]

    init(view: SettingsDetailViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        setupView()
    }

    func setupView() {
        switch view?.settingsType {
        case .goal:
            initialiseGoalView()
        case .favourite:
            initialiseFavView()
        case .coefficient:
            initialiseCoefficientView()
        case .attribution:
            initialiseAttributionView()
        case .about:
            initialiseAboutView()
        case .none:
            print("do something")
        }
    }

    func initialiseGoalView() {
        view?.updateTitle(title: "Change Goal")

        goalValue = view?.userDefaultsController.drinkGoal ?? 2000

        let headingText = "Need to update your goal?"
        let bodyText = """
                    This number is how much you plan to drink daily. It's okay if you need to change it. \
                    It's normal to play around with it a few times until it feels just right.

                    Adjust the slider below to amend it to your liking. \
                    It has a minimum of 1000ml and a maximum of 4000ml.

                    Note: Changing the goal does not affect days that already have a drink entry.
                    """

        view?.setupGoalView(currentGoal: goalValue, headingText: headingText, bodyText: bodyText)
    }

    func initialiseFavView() {
        view?.updateTitle(title: "Change Favourites")

        let headingText = "Fancy a new favourite?"
        let bodyText = """
                    To change a favourite, simply tap the one below you wish the change and choose a new drink \
                    and volume and we'll save it for you.
                    """

        view?.setupFavouritesView(headingText: headingText, bodyText: bodyText)
    }

    func initialiseCoefficientView() {
        view?.updateTitle(title: "Drink Coefficients")
        let headingText = "Drink Coefficients?"
        let bodyText = """
            Drink Coefficients are a representation of how much water is in each ml of a drink.
            A drink with a coefficient of 0.87 will have 87ml of water in it for each 100ml.
            """

        view?.setupCoefficientView(headingText: headingText, bodyText: bodyText)
    }

    func initialiseAttributionView() {
        view?.updateTitle(title: "Thanks to")
        let headingText = "Credits"
        let bodyText = """
            Below are links to frameworks, websites or individuals that have assisted in the creation of Drip.
            """

        view?.setupAttributionView(headingText: headingText, bodyText: bodyText)
    }

    func initialiseAboutView() {
        view?.updateTitle(title: "About")
        let headingText = "About the Developer"
        let bodyText = """
            Hi, my name's Kaiman.

            I'm the Developer of Drip. I hope you're enjoying your experience so far.

            I made Drip because I wanted something simple, smooth and familiar feeling. I can only hope \
            your experiences are similar and you have as much fun using this app as I had making it.
            """
        view?.setupAboutView(headingText: headingText, bodyText: bodyText)
    }

    func creditAlertControllerForRow(row: Int) {
        switch attributeCells[row].title {
        case "Marian Butnaru":
            let title = "Marian Butnaru"
            let message = """
            Marian Butnaru was the designer of the teardrop icon seen used on icon and launchscreen.
            """
            view?.showAlertController(title: title, message: message)
        default:
            break
        }
    }

    func updateGoalValue(newGoal: Double) {
        goalValue = newGoal
    }

    func saveButtonTapped() {
        switch view?.settingsType {
        case .goal:
            view?.userDefaultsController.drinkGoal = goalValue
        default:
            print("do nothing")
        }

        view?.popView()
    }

    // MARK: - Favourites -
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

    func setSelectedFavourite(selected: Int) {
        selectedFavourite = selected
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

        view?.reloadCollectionView()
    }

    // MARK: - Table view -
    func numberOfRowsInSection() -> Int {
        switch view?.settingsType {
        case .coefficient:
            return DrinksList().drinks.count
        case .attribution:
            return attributeCells.count
        default:
            return 0
        }
    }

    func coefficientCellDataForRow(row: Int) -> Beverage {
        return DrinksList().drinks[row]
    }

    func attributionTitleForRow(row: Int) -> String {
        return attributeCells[row].title
    }

    func getAttributionURLforRow(row: Int) -> URL? {
        return attributeCells[row].url
    }
}

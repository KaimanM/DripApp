import XCTest

@testable import Drip

final class MockSettingsDetailView: SettingsDetailViewProtocol {
    var presenter: SettingsDetailPresenterProtocol!

    var userDefaultsController: UserDefaultsControllerProtocol!

    var settingsType: SettingsType!

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

    // swiftlint:disable:next large_tuple
    private(set) var didSetupGoalView: (currentGoal: Double, headingText: String, bodyText: String)?
    func setupGoalView(currentGoal: Double, headingText: String, bodyText: String) {
        didSetupGoalView = (currentGoal: currentGoal, headingText: headingText, bodyText: bodyText)
    }

    private(set) var didSetupFavouritesView: (headingText: String, bodyText: String)?
    func setupFavouritesView(headingText: String, bodyText: String) {
        didSetupFavouritesView = (headingText: headingText, bodyText: bodyText)
    }

    private(set) var didSetupCoefficientView: (headingText: String, bodyText: String)?
    func setupCoefficientView(headingText: String, bodyText: String) {
        didSetupCoefficientView = (headingText: headingText, bodyText: bodyText)
    }

    private(set) var didSetupAttributionView: (headingText: String, bodyText: String)?
    func setupAttributionView(headingText: String, bodyText: String) {
        didSetupAttributionView = (headingText: headingText, bodyText: bodyText)
    }

    private(set) var didSetupAboutView: (headingText: String, bodyText: String)?
    func setupAboutView(headingText: String, bodyText: String) {
        didSetupAboutView = (headingText: headingText, bodyText: bodyText)
    }

    private(set) var didShowAlertController: (title: String, message: String)?
    func showAlertController(title: String, message: String) {
        didShowAlertController = (title: title, message: message)
    }

    private(set) var didPopView: Bool = false
    func popView() {
        didPopView = true
    }

    private(set) var didReloadCollectionView: Bool = false
    func reloadCollectionView() {
        didReloadCollectionView = true
    }
}

class SettingsDetailPresenterTestCase: XCTestCase {
    private var sut: SettingsDetailPresenter!
    private var mockedView = MockSettingsDetailView()
    private var mockedUserDefaultsController = MockUserDefaultsController()

    override func setUp() {
        super.setUp()
        mockedView.userDefaultsController = mockedUserDefaultsController
        sut = SettingsDetailPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_givenGoalSettingsType_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given
        mockedView.settingsType = .goal

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Change Goal")
    }

    func test_givenFavouritesSettingsType_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given
        mockedView.settingsType = .favourite

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Change Favourites")
    }

    func test_givenCoefficientSettingsType_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given
        mockedView.settingsType = .coefficient

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Drink Coefficients")
    }

    func test_givenAboutSettingsType_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given
        mockedView.settingsType = .about

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "About")
    }

    func test_givenAttributionSettingsType_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given
        mockedView.settingsType = .attribution

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Thanks to")
    }

    // MARK: - setupView -

    func test_givenGoalSettingsType_whenSetupViewCalled_thenCallsSetupGoalView() {
        // given
        mockedView.settingsType = .goal

        // when
        sut.setupView()

        //then
        XCTAssertEqual(mockedView.didSetupGoalView?.currentGoal, 2000)
        XCTAssertEqual(mockedView.didSetupGoalView?.headingText, "Need to update your goal?")
        XCTAssertEqual(mockedView.didSetupGoalView?.bodyText,
                                """
                                This number is how much you plan to drink daily. It's okay if you need to change it. \
                                It's normal to play around with it a few times until it feels just right.

                                Adjust the slider below to amend it to your liking. \
                                It has a minimum of 1000ml and a maximum of 4000ml.

                                Note: Changing the goal does not affect days that already have a drink entry.
                                """)
    }

    func test_givenFavouritesSettingsType_whenSetupViewCalled_thenCallsSetupFavouritesView() {
        // given
        mockedView.settingsType = .favourite

        // when
        sut.setupView()

        //then
        XCTAssertEqual(mockedView.didSetupFavouritesView?.headingText, "Fancy a new favourite?")
        XCTAssertEqual(mockedView.didSetupFavouritesView?.bodyText,
                                """
                                To change a favourite, simply tap the one below you wish the change and \
                                choose a new drink and volume and we'll save it for you.
                                """)
    }

    func test_givenCoefficientSettingsType_whenSetupViewCalled_thenCallsSetupCoefficientView() {
        // given
        mockedView.settingsType = .coefficient

        // when
        sut.setupView()

        //then
        XCTAssertEqual(mockedView.didSetupCoefficientView?.headingText, "Drink Coefficients?")
        XCTAssertEqual(mockedView.didSetupCoefficientView?.bodyText,
                                """
                                Drink Coefficients are a representation of how much water is in each ml of a drink.
                                A drink with a coefficient of 0.87 will have 87ml of water in it for each 100ml.
                                """)
    }

    func test_givenAttributionSettingsType_whenSetupViewCalled_thenCallsSetupAboutView() {
        // given
        mockedView.settingsType = .attribution

        // when
        sut.setupView()

        //then
        XCTAssertEqual(mockedView.didSetupAttributionView?.headingText, "Credits")
        XCTAssertEqual(mockedView.didSetupAttributionView?.bodyText,
                                """
                                Below are links to frameworks, websites or individuals that have assisted \
                                in the creation of Drip.
                                """)
    }

    func test_givenAboutSettingsType_whenSetupViewCalled_thenCallsSetupAboutView() {
        // given
        mockedView.settingsType = .about

        // when
        sut.setupView()

        //then
        XCTAssertEqual(mockedView.didSetupAboutView?.headingText, "About the Developer")
        XCTAssertEqual(mockedView.didSetupAboutView?.bodyText,
                                """
                                Hi, my name's Kaiman.

                                I'm the Developer of Drip. I hope you're enjoying your experience so far.

                                I made Drip because I wanted something simple, smooth and familiar feeling. \
                                I can only hope your experiences are similar and you have as much fun using \
                                this app as I had making it.
                                """)
    }

    // MARK: - creditAlertControllerForRow -

    func test_givenRow6_whenCreditAlertControllerForRowCalled_thenShowsAlertControllerWithCorrectInfo() {
        //given and when
        sut.creditAlertControllerForRow(row: 6)

        //then
        XCTAssertEqual(mockedView.didShowAlertController?.title, "Marian Butnaru")
        XCTAssertEqual(mockedView.didShowAlertController?.message,
                       """
                       Marian Butnaru was the designer of the teardrop icon seen used on icon and launchscreen.
                       """)
    }

    // MARK: - updateGoalValue -

    func test_whenUpdateGoalValueCalled_thenUpdatesGoalValue() {
        // when
        sut.updateGoalValue(newGoal: 1500)

        // then
        XCTAssertEqual(sut.goalValue, 1500)
    }

    // MARK: - SaveButtonTapped -

    func test_givenSettingsTypeGoalAndNewGoal_whenSaveButtonTappedCalled_thenSavesGoalValueAndCallsPopView() {
        // given
        mockedView.settingsType = .goal
        sut.goalValue = 1600

        // when
        sut.saveButtonTapped()

        // then
        XCTAssertEqual(mockedUserDefaultsController.drinkGoal, 1600)
        XCTAssertTrue(mockedView.didPopView)
    }

    // MARK: - drinkForCellAt -

    func test_givenIndex0_whenDrinkForCellAtCalled_returnsCorrectDrink() {
        //given & when
        let cellData = sut.drinkForCellAt(index: 0)

        // then
        XCTAssertEqual(cellData.imageName, "MD1.svg")
        XCTAssertEqual(cellData.volume, 100)
    }

    func test_givenIndex1_whenDrinkForCellAtCalled_returnsCorrectDrink() {
        //given & when
        let cellData = sut.drinkForCellAt(index: 1)

        // then
        XCTAssertEqual(cellData.imageName, "MD2.svg")
        XCTAssertEqual(cellData.volume, 200)
    }

    func test_givenIndex2_whenDrinkForCellAtCalled_returnsCorrectDrink() {
        //given & when
        let cellData = sut.drinkForCellAt(index: 2)

        // then
        XCTAssertEqual(cellData.imageName, "MD3.svg")
        XCTAssertEqual(cellData.volume, 300)
    }

    func test_givenIndex3_whenDrinkForCellAtCalled_returnsCorrectDrink() {
        //given & when
        let cellData = sut.drinkForCellAt(index: 3)

        // then
        XCTAssertEqual(cellData.imageName, "MD4.svg")
        XCTAssertEqual(cellData.volume, 400)
    }

    func test_givenIndex5_whenDrinkForCellAtCalled_returnsCorrectDrink() {
        //given & when
        let cellData = sut.drinkForCellAt(index: 5)

        // then
        XCTAssertEqual(cellData.imageName, "MD1.svg")
        XCTAssertEqual(cellData.volume, 100)
    }

    // MARK: - setSelectedFavourite -

    func test_whenSetSelectedFavoruiteCalled_thenUpdatesFavourite() {
        // when
        sut.setSelectedFavourite(selected: 2)

        //then
        XCTAssertEqual(sut.selectedFavourite, 2)
    }

    // MARK: - addFavourite -

    func test_givenSelectedIndex0_whenAddFavouriteCalled_thenUpdatesCorrectFavourite() {
        // given
        sut.selectedFavourite = 0

        // when
        sut.addFavourite(name: "test", volume: 333, imageName: "testy")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Name, "test")
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Volume, 333)
        XCTAssertEqual(mockedUserDefaultsController.favDrink1ImageName, "testy")
    }

    func test_givenSelectedIndex1_whenAddFavouriteCalled_thenUpdatesCorrectFavourite() {
        // given
        sut.selectedFavourite = 1

        // when
        sut.addFavourite(name: "test", volume: 444, imageName: "testy")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Name, "test")
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Volume, 444)
        XCTAssertEqual(mockedUserDefaultsController.favDrink2ImageName, "testy")
    }

    func test_givenSelectedIndex2_whenAddFavouriteCalled_thenUpdatesCorrectFavourite() {
        // given
        sut.selectedFavourite = 2

        // when
        sut.addFavourite(name: "test", volume: 555, imageName: "testy")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Name, "test")
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Volume, 555)
        XCTAssertEqual(mockedUserDefaultsController.favDrink3ImageName, "testy")
    }

    func test_givenSelectedIndex3_whenAddFavouriteCalled_thenUpdatesCorrectFavourite() {
        // given
        sut.selectedFavourite = 3

        // when
        sut.addFavourite(name: "test", volume: 777, imageName: "testy")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Name, "test")
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Volume, 777)
        XCTAssertEqual(mockedUserDefaultsController.favDrink4ImageName, "testy")
    }

    // MARK: - numberOfRowsInSection -

    func test_givenCoefficientSettingsType_whenNumberOfRowsInSectionCalled_thenReturnsCorrectValue() {
        //given
        mockedView.settingsType = .coefficient

        // when & then
        XCTAssertEqual(sut.numberOfRowsInSection(), DrinksList().drinks.count)
    }

    func test_givenAttributionSettingsType_whenNumberOfRowsInSectionCalled_thenReturnsCorrectValue() {
        //given
        mockedView.settingsType = .attribution

        // when & then
        XCTAssertEqual(sut.numberOfRowsInSection(), sut.attributeCells.count)
    }
}

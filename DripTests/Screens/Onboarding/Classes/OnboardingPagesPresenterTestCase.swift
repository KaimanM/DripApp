import XCTest
import CoreData

@testable import Drip

final class MockOnboardingPagesView: OnboardingPagesViewProtocol {

    var notificationController: LocalNotificationControllerProtocol!
    var presenter: OnboardingPagesPresenterProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!

    private(set) var didSetToggleStatus: Bool = false
    func setToggleStatus(isOn: Bool) {
        didSetToggleStatus = isOn
    }

    private(set) var didShowSettingsNotificationDialogue: Bool = false
    func showSettingsNotificationDialogue() {
        didShowSettingsNotificationDialogue = true
    }
}

class OnboardingPagesPresenterTestCase: XCTestCase {
    private var sut: OnboardingPagesPresenter!
    private var mockedView = MockOnboardingPagesView()
    private var mockedUserDefaultsController = MockUserDefaultsController()
    private var mockedNotificationController = MockLocalNotificationController()

    override func setUp() {
        super.setUp()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.notificationController = mockedNotificationController
        sut = OnboardingPagesPresenter(view: mockedView)
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesCurrentVersionInUserDefaults() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedUserDefaultsController.currentVersion, Bundle.main.appVersion)
    }

    // MARK: - SetSelectedFavourite -

    func test_whenSetSelectedFavouriteCalled_thenUpdatesSelectedFavourite() {
        // given & when
        sut.setSelectedFavourite(selected: 1)

        // then
        XCTAssertEqual(sut.selectedFavourite, 1)
    }

    // MARK: - drinkForCellAt -

    func test_whenDrinkForCellAtIndex0Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 0)

        // then
        XCTAssertEqual(cellData.imageName, "MD1.pdf")
        XCTAssertEqual(cellData.volume, 100)
    }

    func test_whenDrinkForCellAtIndex1Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 1)

        // then
        XCTAssertEqual(cellData.imageName, "MD2.pdf")
        XCTAssertEqual(cellData.volume, 200)
    }

    func test_whenDrinkForCellAtIndex2Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 2)

        // then
        XCTAssertEqual(cellData.imageName, "MD3.pdf")
        XCTAssertEqual(cellData.volume, 300)
    }

    func test_whenDrinkForCellAtIndex3Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 3)

        // then
        XCTAssertEqual(cellData.imageName, "MD4.pdf")
        XCTAssertEqual(cellData.volume, 400)
    }

    func test_whenDrinkForCellAtIndex5Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 5)

        // then
        XCTAssertEqual(cellData.imageName, "MD1.pdf")
        XCTAssertEqual(cellData.volume, 100)
    }

    func test_whenDrinkForCellAtCalledAndViewHasNoUserDefaults_thenReturnsCorrectValues() {
        // given & when
        let mockedView = MockOnboardingPagesView()
        sut = OnboardingPagesPresenter(view: mockedView)
        let cellData = sut.drinkForCellAt(index: 3)

        // then
        XCTAssertEqual(cellData.imageName, "waterbottle.svg")
        XCTAssertEqual(cellData.volume, 100)
    }

    // MARK: - addFavourite -

    func test_givenSelectedIndexIs0_whenAddFavouriteCalled_thenUpdatesFav1() {
        // given
        sut.selectedFavourite = 0

        // when
        sut.addFavourite(beverage: Beverage(name: "Test", imageName: "test", coefficient: 1.0), volume: 333)

        // then
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.name, "Test")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.imageName, "test")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.coefficient, 1)
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Volume, 333)
    }

    func test_givenSelectedIndexIs1_whenAddFavouriteCalled_thenUpdatesFav2() {
        // given
        sut.selectedFavourite = 1

        // when
        sut.addFavourite(beverage: Beverage(name: "Test2", imageName: "test2", coefficient: 2.0), volume: 444)

        // then
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.name, "Test2")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.imageName, "test2")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.coefficient, 2)
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Volume, 444)
    }

    func test_givenSelectedIndexIs2_whenAddFavouriteCalled_thenUpdatesFav3() {
        // given
        sut.selectedFavourite = 2

        // when
        sut.addFavourite(beverage: Beverage(name: "Test3", imageName: "test3", coefficient: 3.0), volume: 555)

        // then
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.name, "Test3")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.imageName, "test3")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.coefficient, 3)
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Volume, 555)
    }

    func test_givenSelectedIndexIs3_whenAddFavouriteCalledAnd_thenUpdatesFav4() {
        // given
        sut.selectedFavourite = 3

        // when
        sut.addFavourite(beverage: Beverage(name: "Test4", imageName: "test4", coefficient: 4.0), volume: 777)

        // then
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.name, "Test4")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.imageName, "test4")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.coefficient, 4)
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Volume, 777)
    }

    func test_givenSelectedIndexIs4_whenAddFavouriteCalledAnd_thenUpdatesNothing() {
        // given
        sut.selectedFavourite = 4

        // when
        sut.addFavourite(beverage: Beverage(name: "Test5", imageName: "test5", coefficient: 4.0), volume: 777)

        // then
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.name, "MockDrink1")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.imageName, "MD1.pdf")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage1.coefficient, 1)
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Volume, 100)
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.name, "MockDrink2")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.imageName, "MD2.pdf")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage2.coefficient, 1)
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Volume, 200)
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.name, "MockDrink3")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.imageName, "MD3.pdf")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage3.coefficient, 1)
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Volume, 300)
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.name, "MockDrink4")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.imageName, "MD4.pdf")
        XCTAssertEqual(mockedUserDefaultsController.favBeverage4.coefficient, 1)
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Volume, 400)

    }

    // MARK: - setNameAndGoal -

    func test_whenSetNameAndGoalCalled_thenUpdatesFav4() {
        // when
        sut.setNameAndGoal(name: "Iron Man", goal: 3070)

        // then
        XCTAssertEqual(mockedUserDefaultsController.name, "Iron Man")
        XCTAssertEqual(mockedUserDefaultsController.drinkGoal, 3070)
    }

    // MARK: - didCompleteOnboarding -

    func test_whenDidCompleteOnboardingCalled_thenSetsCompletedOnboardingTrue() {
        // when
        sut.didCompleteOnboarding()

        // then
        XCTAssertEqual(mockedUserDefaultsController.completedOnboarding, true)
    }

    // MARK: - onSwitchToggle -

    func test_givenAuthorisedAuthStatus_whenOnSwitchToggleCalledWithTrue_thenCallsCorrectFunctions() {
        // given
        mockedNotificationController.authStatus = .authorized
        let expectation = self.expectation(description: "switch toggle test")

        DispatchQueue.main.async {
            // when
            self.sut.onSwitchToggle(isOn: true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertTrue(self.mockedView.didSetToggleStatus)
        XCTAssertTrue(self.mockedUserDefaultsController.enabledNotifications)
    }

    func test_givenProvisionalAuthStatus_whenOnSwitchToggleCalledWithTrue_thenCallsCorrectFunctions() {
        // given
        mockedNotificationController.authStatus = .provisional
        let expectation = self.expectation(description: "switch toggle test")

        DispatchQueue.main.async {
            // when
            self.sut.onSwitchToggle(isOn: true)
            expectation.fulfill()

        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertTrue(self.mockedView.didSetToggleStatus)
        XCTAssertTrue(self.mockedUserDefaultsController.enabledNotifications)
    }

    func test_givenNotDeterminedAuthStatusAndGrantedTrue_whenOnSwitchToggleCalledWithTrue_thenCallsCorrectFunctions() {
        // given
        mockedNotificationController.authStatus = .notDetermined
        mockedNotificationController.grantedAuth = true
        let expectation = self.expectation(description: "switch toggle test")

        DispatchQueue.main.async {
            // when
            self.sut.onSwitchToggle(isOn: true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertTrue(self.mockedView.didSetToggleStatus)
        XCTAssertTrue(self.mockedUserDefaultsController.enabledNotifications)
    }

    func test_givenNotDeterminedAuthStatusAndGrantedFalse_whenOnSwitchToggleCalledWithTrue_thenCallsCorrectFunctions() {
        // given
        mockedNotificationController.authStatus = .notDetermined
        mockedNotificationController.grantedAuth = false
        let expectation = self.expectation(description: "switch toggle test")

        DispatchQueue.main.async {
            // when
            self.sut.onSwitchToggle(isOn: true)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertFalse(self.mockedView.didSetToggleStatus)
        XCTAssertFalse(self.mockedUserDefaultsController.enabledNotifications)
        XCTAssertTrue(self.mockedView.didShowSettingsNotificationDialogue)
    }

    func test_whenOnSwitchToggleCalledWithFalse_thenCallsCorrectFunctions() {
        // when
        sut.onSwitchToggle(isOn: false)

        // then
        XCTAssertFalse(mockedView.didSetToggleStatus)
        XCTAssertFalse(mockedUserDefaultsController.enabledNotifications)
    }

}

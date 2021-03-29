import XCTest
import CoreData

@testable import Drip

final class MockOnboardingPagesView: OnboardingPagesViewProtocol {
    var presenter: OnboardingPagesPresenterProtocol!

    var userDefaultsController: UserDefaultsControllerProtocol!
}

class OnboardingPagesPresenterTestCase: XCTestCase {
    private var sut: OnboardingPagesPresenter!
    private var mockedView = MockOnboardingPagesView()
    private var mockedUserDefaultsController = MockUserDefaultsController()

    override func setUp() {
        super.setUp()
        mockedView.userDefaultsController = mockedUserDefaultsController
        sut = OnboardingPagesPresenter(view: mockedView)
    }

    override func tearDown() {
        super.tearDown()
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
        XCTAssertEqual(cellData.imageName, "MD1.svg")
        XCTAssertEqual(cellData.volume, 100)
    }

    func test_whenDrinkForCellAtIndex1Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 1)

        // then
        XCTAssertEqual(cellData.imageName, "MD2.svg")
        XCTAssertEqual(cellData.volume, 200)
    }

    func test_whenDrinkForCellAtIndex2Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 2)

        // then
        XCTAssertEqual(cellData.imageName, "MD3.svg")
        XCTAssertEqual(cellData.volume, 300)
    }

    func test_whenDrinkForCellAtIndex3Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 3)

        // then
        XCTAssertEqual(cellData.imageName, "MD4.svg")
        XCTAssertEqual(cellData.volume, 400)
    }

    func test_whenDrinkForCellAtIndex5Called_thenReturnsCorrectValues() {
        // given & when
        let cellData = sut.drinkForCellAt(index: 5)

        // then
        XCTAssertEqual(cellData.imageName, "MD1.svg")
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
        sut.addFavourite(name: "Test", volume: 333, imageName: "test.svg")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Name, "Test")
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Volume, 333)
        XCTAssertEqual(mockedUserDefaultsController.favDrink1ImageName, "test.svg")
    }

    func test_givenSelectedIndexIs1_whenAddFavouriteCalled_thenUpdatesFav2() {
        // given
        sut.selectedFavourite = 1

        // when
        sut.addFavourite(name: "Test2", volume: 444, imageName: "test2.svg")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Name, "Test2")
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Volume, 444)
        XCTAssertEqual(mockedUserDefaultsController.favDrink2ImageName, "test2.svg")
    }

    func test_givenSelectedIndexIs2_whenAddFavouriteCalled_thenUpdatesFav3() {
        // given
        sut.selectedFavourite = 2

        // when
        sut.addFavourite(name: "Test3", volume: 555, imageName: "test3.svg")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Name, "Test3")
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Volume, 555)
        XCTAssertEqual(mockedUserDefaultsController.favDrink3ImageName, "test3.svg")
    }

    func test_givenSelectedIndexIs3_whenAddFavouriteCalledAnd_thenUpdatesFav4() {
        // given
        sut.selectedFavourite = 3

        // when
        sut.addFavourite(name: "Test4", volume: 666, imageName: "test4.svg")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Name, "Test4")
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Volume, 666)
        XCTAssertEqual(mockedUserDefaultsController.favDrink4ImageName, "test4.svg")
    }

    func test_givenSelectedIndexIs4_whenAddFavouriteCalledAnd_thenUpdatesNothing() {
        // given
        sut.selectedFavourite = 4

        // when
        sut.addFavourite(name: "Test5", volume: 777, imageName: "test5.svg")

        // then
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Name, "MockDrink1")
        XCTAssertEqual(mockedUserDefaultsController.favDrink1Volume, 100)
        XCTAssertEqual(mockedUserDefaultsController.favDrink1ImageName, "MD1.svg")
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Name, "MockDrink2")
        XCTAssertEqual(mockedUserDefaultsController.favDrink2Volume, 200)
        XCTAssertEqual(mockedUserDefaultsController.favDrink2ImageName, "MD2.svg")
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Name, "MockDrink3")
        XCTAssertEqual(mockedUserDefaultsController.favDrink3Volume, 300)
        XCTAssertEqual(mockedUserDefaultsController.favDrink3ImageName, "MD3.svg")
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Name, "MockDrink4")
        XCTAssertEqual(mockedUserDefaultsController.favDrink4Volume, 400)
        XCTAssertEqual(mockedUserDefaultsController.favDrink4ImageName, "MD4.svg")
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

}

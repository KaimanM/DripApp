import XCTest
import CoreData

@testable import Drip

final class MockAwardsView: AwardsViewProtocol {
    var presenter: AwardsPresenterProtocol!

    var coreDataController: CoreDataControllerProtocol!

    var userDefaultsController: UserDefaultsControllerProtocol!

    private(set) var didPresentViewController: UIViewController?
    func presentView(_ view: UIViewController) {
        didPresentViewController = view
    }

    private(set) var didShowViewController: UIViewController?
    func showView(_ view: UIViewController) {
        didShowViewController = view
    }

    private(set) var didPushViewController: UIViewController?
    func pushView(_ view: UIViewController) {
        didPushViewController = view
    }

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

    private(set) var didReloadData: Bool = false
    func reloadData() {
        didReloadData = true
    }
}

class AwardsPresenterTestCase: XCTestCase {
    private var sut: AwardsPresenter!
    private var mockedView = MockAwardsView()
    private var coreDataController = CoreDataController.shared
    private var mockedUserDefaultsController = MockUserDefaultsController()

    override func setUp() {
        super.setUp()
        flushCoreData()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.coreDataController = coreDataController
        sut = AwardsPresenter(view: mockedView)
    }

    func flushCoreData() {
        for entry in coreDataController.fetchDrinks(from: nil) {
            coreDataController.deleteEntry(entry: entry)
        }
        for award in coreDataController.fetchUnlockedAwards() {
            coreDataController.deleteAward(award: award)
        }
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Awards")
    }

    // MARK: - onViewDidAppear -

    func test_whenOnViewDidAppearCalled_thenReloadsData() {
        // when
        sut.onViewDidAppear()

        // then
        XCTAssertTrue(mockedView.didReloadData)
    }

    // MARK: - fetchUnlockedAwards -

    func test_givenNoData_whenFetchUnlockedAwardsCalled_thenUnlockedAwardsIsEmpty() {
        // when
        sut.fetchUnlockedAwards()

        // then
        XCTAssertTrue(sut.unlockedAwards.isEmpty)
    }

    func test_given10DrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAward() {
        // given
        for _ in 1...10 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 200,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(0))
    }

    func test_given50DrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for _ in 1...50 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 200,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(0))
        XCTAssertTrue(unlockedAwardIds.contains(1))
    }

    func test_given100DrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for _ in 1...100 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 200,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(0))
        XCTAssertTrue(unlockedAwardIds.contains(1))
        XCTAssertTrue(unlockedAwardIds.contains(2))
    }

    func test_given500DrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for _ in 1...500 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 200,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(0))
        XCTAssertTrue(unlockedAwardIds.contains(1))
        XCTAssertTrue(unlockedAwardIds.contains(2))
        XCTAssertTrue(unlockedAwardIds.contains(3))
    }

    func test_given7DaysInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        var date = Date()
        for _ in 1...7 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: date)
            date = date.dayBefore
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(4))
    }

    func test_given28DaysInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        var date = Date()
        for _ in 1...28 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: date)
            date = date.dayBefore
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(4))
        XCTAssertTrue(unlockedAwardIds.contains(5))
    }

    func test_given90DaysInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        var date = Date()
        for _ in 1...90 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: date)
            date = date.dayBefore
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(4))
        XCTAssertTrue(unlockedAwardIds.contains(5))
        XCTAssertTrue(unlockedAwardIds.contains(6))
    }

    func test_given365DaysInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        var date = Date()
        for _ in 1...365 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: date)
            date = date.dayBefore
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(4))
        XCTAssertTrue(unlockedAwardIds.contains(5))
        XCTAssertTrue(unlockedAwardIds.contains(6))
        XCTAssertTrue(unlockedAwardIds.contains(7))
    }

    func test_given3UniqueDrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for index in 1...3 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test\(index)",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(8))
    }

    func test_given5UniqueDrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for index in 1...5 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test\(index)",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(8))
        XCTAssertTrue(unlockedAwardIds.contains(9))
    }

    func test_given7UniqueDrinksInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        for index in 1...7 {
            coreDataController.addDrinkForDay(beverage: Beverage(name: "test\(index)",
                                                                 imageName: "test",
                                                                 coefficient: 1),
                                              volume: 3000,
                                              timeStamp: Date())
        }

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(8))
        XCTAssertTrue(unlockedAwardIds.contains(9))
        XCTAssertTrue(unlockedAwardIds.contains(10))
    }

    func test_given1000mlDrinkInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                             imageName: "test",
                                                             coefficient: 1),
                                          volume: 1000,
                                          timeStamp: Date())
        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(11))
    }

    func test_given50mlDrinkInCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        coreDataController.addDrinkForDay(beverage: Beverage(name: "test",
                                                             imageName: "test",
                                                             coefficient: 1),
                                          volume: 50,
                                          timeStamp: Date())

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(12))
    }

    func test_givenAwardWithId13InCoreData_whenFetchUnlockedAwardsCalled_thenUnlocksCorrectAwards() {
        // given
        coreDataController.unlockAwardWithId(id: 13)

        // when
        sut.fetchUnlockedAwards()

        // then
        let unlockedAwardIds = sut.unlockedAwards.map({ $0.id })
        XCTAssertTrue(unlockedAwardIds.contains(13))
    }

    // MARK: - cellForRowAt -

    func test_givenNoUnlockedAwards_whenCellForRowAtCalled_thenReturnsLockedData() {
        // when
        let data = sut.cellForRowAt(index: 0)

        // then
        XCTAssertEqual(data.title, "???")
        XCTAssertEqual(data.imageName, "isLocked.pdf")

    }

    func test_givenAward0Unlocked_whenCellForRowAtCalled_thenReturnsCorrectData() {
        //given
        coreDataController.unlockAwardWithId(id: 0)
        sut.fetchUnlockedAwards()

        // when
        let data = sut.cellForRowAt(index: 0)

        // then
        XCTAssertEqual(data.title, "A tenner!")
        XCTAssertEqual(data.imageName, "10drinks.pdf")
    }

    // MARK: - didSelectItemAt -

    func test_givenNoUnlockedAwards_whenDidSelectItemAtCalled_thenPushesViewWithCorrectData() {
        // when
        sut.didSelectItemAt(index: 0)

        // then
        XCTAssertTrue(mockedView.didPushViewController is AwardsDetailView)
        XCTAssertTrue((mockedView.didPushViewController as? AwardsDetailView)?.dataSource is LockedAwardDataSource)
        XCTAssertNil((mockedView.didPushViewController as? AwardsDetailView)?.timeStamp)
    }

    func test_givenAward0Unlocked_whenDidSelectItemAtCalled_thenPushesViewWithCorrectData() {
        //given
        coreDataController.unlockAwardWithId(id: 0)
        sut.fetchUnlockedAwards()

        // when
        sut.didSelectItemAt(index: 0)

        // then
        XCTAssertTrue(mockedView.didPushViewController is AwardsDetailView)
        XCTAssertTrue((mockedView.didPushViewController as? AwardsDetailView)?.dataSource is TenDrinksAwardDataSource)
        XCTAssertNotNil((mockedView.didPushViewController as? AwardsDetailView)?.timeStamp)
    }

    // MARK: - numberOfItemsInSection -

    func test_whenNumberOfItemsInSectionCalled_thenReturns14() {
        // when & then
        XCTAssertEqual(sut.numberOfItemsInSection(), 14)
    }
}

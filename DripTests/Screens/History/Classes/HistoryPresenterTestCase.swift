import XCTest
import CoreData

@testable import Drip

final class MockHistoryView: HistoryViewProtocol {
    var presenter: HistoryPresenterProtocol!

    var coreDataController: CoreDataControllerProtocol! = CoreDataController.shared
    var userDefaultsController: UserDefaultsControllerProtocol!  = UserDefaultsController.shared
    var healthKitController: HealthKitControllerProtocol!

    //swiftlint:disable:next large_tuple
    private(set) var didUpdateRingView: (progress: CGFloat, date: Date, total: Double, goal: Double)?
    func updateRingView(progress: CGFloat, date: Date, total: Double, goal: Double) {
        didUpdateRingView = (progress: progress, date: date, total: total, goal: goal)
    }

    private(set) var didPresentViewController: UIViewController?
    func presentView(_ view: UIViewController) {
        didPresentViewController = view
    }

    private(set) var didShowViewController: UIViewController?
    func showView(_ view: UIViewController) {
        didShowViewController = view
    }

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

    private(set) var didUpdateEditButton: String?
    func updateEditButton(title: String) {
        didUpdateEditButton = title
    }

    private(set) var didCallSetupCalendar: Bool = false
    func setupCalendar() {
        didCallSetupCalendar = true
    }

    private(set) var didCallSetupInfoPanel: Bool = false
    func setupInfoPanel() {
        didCallSetupInfoPanel = true
    }

    private(set) var didCallRefreshUI: Bool = false
    func refreshUI() {
        didCallRefreshUI = true
    }

}

class HistoryPresenterTestCase: XCTestCase {
    private var sut: HistoryPresenter!
    private var mockedView = MockHistoryView()
    private var coreDataController = CoreDataController.shared
    private var mockedUserDefaultsController = MockUserDefaultsController()
    private var mockedHealthKitController = MockHealthKitController()

    override func setUp() {
        super.setUp()
        flushCoreData()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.healthKitController = mockedHealthKitController
        sut = HistoryPresenter(view: mockedView)
    }

    func flushCoreData() {
        for entry in coreDataController.fetchDrinks(from: nil) {
            coreDataController.deleteEntry(entry: entry)
        }
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "History")
    }

    func test_whenOnViewDidLoadCalled_thenUpdatesButton() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateEditButton!, "Toggle Edit")
    }

    func test_whenOnViewDidLoadCalled_thenSetsUpCalendar() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertTrue(mockedView.didCallSetupCalendar)
    }

    func test_whenOnViewDidLoadCalled_thenSetsUpInfoPanel() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertTrue(mockedView.didCallSetupInfoPanel)
    }

    // MARK: - onViewDidAppear -

    func test_given0DrinksInCoreData_whenOnViewDidAppearCalled_thenPopulatesDrinksAndUpdatesRingView() {
        // given & when
        sut.onViewDidAppear()

        // then
        XCTAssertEqual(sut.selectedDayDrinks.count, 0)
        XCTAssertEqual(mockedView.didUpdateRingView?.progress, 0/2000)
        XCTAssertTrue(Calendar.current.isDate(mockedView.didUpdateRingView!.date, inSameDayAs: Date()))
        XCTAssertEqual(mockedView.didUpdateRingView?.total, 0)
        XCTAssertEqual(mockedView.didUpdateRingView?.goal, 2000)
    }

    func test_whenOnViewDidAppearCalled_thenPopulatesDrinksAndUpdatesRingView() {
        // given & when
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 250,
                                          timeStamp: Date())
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 500,
                                          timeStamp: Date())
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 1000,
                                          timeStamp: Date())
        sut.onViewDidAppear()

        // then
        XCTAssertEqual(sut.selectedDayDrinks.count, 3)
        XCTAssertEqual(mockedView.didUpdateRingView?.progress, 1750/2000)
        XCTAssertTrue(Calendar.current.isDate(mockedView.didUpdateRingView!.date, inSameDayAs: Date()))
        XCTAssertEqual(mockedView.didUpdateRingView?.total, 1750)
        XCTAssertEqual(mockedView.didUpdateRingView?.goal, 2000)
    }

    // MARK: - editToggleTapped -

    func test_givenEditingModeIsFalse_whenEditingButtonTappedCalled_thenUpdatesButtonAndValue() {
        // given
        sut.editingMode = false

        // when
        sut.editToggleTapped()

        // then
        XCTAssertTrue(sut.editingMode)
        XCTAssertEqual(mockedView.didUpdateEditButton, "Finished")
        XCTAssertTrue(mockedView.didCallRefreshUI)
    }

    func test_givenEditingModeIsTrue_whenEditingButtonTappedCalled_thenUpdatesButtonAndValue() {
        // given
        sut.editingMode = true

        // when
        sut.editToggleTapped()

        // then
        XCTAssertFalse(sut.editingMode)
        XCTAssertEqual(mockedView.didUpdateEditButton, "Toggle Edit")
        XCTAssertTrue(mockedView.didCallRefreshUI)
    }

    // MARK: - isHidingEditButton -

    func test_givenEditingModeIsFalse_whenIsHidingEditButtonCalled_thenReturnsTrue() {
        // given
        sut.editingMode = false

        // then
        XCTAssertTrue(sut.isHidingEditButton())
    }

    func test_givenEditingModeIsTrue_whenIsHidingEditButtonCalled_thenReturnsFalse() {
        // given
        sut.editingMode = true

        // then
        XCTAssertFalse(sut.isHidingEditButton())
    }

    // MARK: - cellForDate -

    func test_givenSingleDrinkOf250_whenCellForDateCalled_thenReturnsCorrectProgressForRingView() {
        // given
//        coreDataController.addDrinkForDay(name: "testDrink", volume: 250, imageName: "testImage", timeStamp: Date())
        sut.selectedDate = Date()
        sut.addDrinkTapped(beverage: Beverage(name: "test",
                                              imageName: "testImageName",
                                              coefficient: 1),
                           volume: 250)

        // then
        XCTAssertEqual(sut.cellForDate(date: Date()), 250/2000)
    }
    func test_givenNoDrink_whenCellForDateCalled_thenReturnsCorrectProgressForRingView() {
        // then
        XCTAssertEqual(sut.cellForDate(date: Date()), 0)
    }

    // MARK: - TableView -

    func test_given3ItemsInCoreData_numberOfRowsInSectionReturnsCorrectValue() {
        // given
        sut.selectedDate = Date()
        sut.addDrinkTapped(beverage: Beverage(name: "test",
                                              imageName: "testImageName",
                                              coefficient: 1),
                           volume: 250)
        sut.addDrinkTapped(beverage: Beverage(name: "test",
                                              imageName: "testImageName",
                                              coefficient: 1),
                           volume: 250)
        sut.addDrinkTapped(beverage: Beverage(name: "test",
                                              imageName: "testImageName",
                                              coefficient: 1),
                           volume: 250)

        // then
        XCTAssertEqual(sut.numberOfRowsInSection(), 3)
    }

    func test_givenMockDrink_whenCellForRowAtCalled_thenReturnsCorrectTupleOfData() {
        //given
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 20
        dateComponents.minute = 15
        sut.selectedDate = Calendar.current.date(from: dateComponents)!
        sut.addDrinkTapped(beverage: Beverage(name: "test",
                                              imageName: "testImageName",
                                              coefficient: 1),
                           volume: 250)

        // when
        let testCell = sut.cellForRowAt(row: 0)

        // then
        XCTAssertEqual(testCell.name, "test")
        XCTAssertEqual(testCell.volume, "250ml")
        XCTAssertEqual(testCell.timeStampTitle, "At 20:15")
        XCTAssertEqual(testCell.imageName, "testImageName")
    }

    func test_givenDeleteButtonTapped_thenPresentsUIAlertControllerConfirmingDelete() {
        // given
        sut.didTapDeleteButton(row: 0)

        // then
        XCTAssertTrue(mockedView.didPresentViewController!.isKind(of: UIAlertController.self))
    }

    // MARK: - addDrinkTapped -

    func test_givenHealthKitEnabled_whenAddDrinkTappedCalled_thenHealthKitRecordsUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = true
        sut.selectedDate = Date()
        let drink = Beverage(name: "Water",
                             imageName: "waterbottle.svg",
                             coefficient: 1.0)

        // when
        sut.addDrinkTapped(beverage: drink,
                           volume: 500)

        // then
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.amount, 500)
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.date, sut.selectedDate)
    }

    func test_givenHealthKitDisabled_whenAddDrinkTappedCalled_thenHealthKitRecordsNotUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = false
        sut.selectedDate = Date()
        let drink = Beverage(name: "Water",
                             imageName: "waterbottle.svg",
                             coefficient: 1.0)

        // when
        sut.addDrinkTapped(beverage: drink,
                           volume: 500)

        // then
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.amount, nil)
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.date, nil)
    }

    // MARK: - deleteHealthKitEntry -

    func test_givenHealthKitEnabledVolumeAndTimeStamp_whenDeleteHealthKitEntryCalled_thenHealthKitRecordsUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = true
        let timeStamp = Date()
        let volume = 500.0

        // when
        sut.deleteHealthKitEntry(volume: volume, timeStamp: timeStamp)

        // then
        XCTAssertEqual(mockedHealthKitController.deletedEntry?.amount, volume)
        XCTAssertEqual(mockedHealthKitController.deletedEntry?.date, timeStamp)
    }

    func test_givenHealthKitDisabledVolumeAndTimeStamp_whenDeleteHealthKitEntryCalled_thenHealthKitRecordsUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = false
        let timeStamp = Date()
        let volume = 500.0

        // when
        sut.deleteHealthKitEntry(volume: volume, timeStamp: timeStamp)

        // then
        XCTAssertEqual(mockedHealthKitController.deletedEntry?.amount, nil)
        XCTAssertEqual(mockedHealthKitController.deletedEntry?.date, nil)
    }
}

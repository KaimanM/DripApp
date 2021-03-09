import XCTest
import CoreData

@testable import Drip

final class MockTodayView: TodayViewProtocol {
    var coreDataController: CoreDataControllerProtocol!

    var presenter: TodayPresenterProtocol!

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

    // swiftlint:disable:next large_tuple
    private(set) var didSetupRingView: (startColor: UIColor, endColor: UIColor, ringWidth: CGFloat)?
    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        didSetupRingView = (startColor: startColor, endColor: endColor, ringWidth: ringWidth)
    }

    private(set) var didSetRingProgress: Double?
    func setRingProgress(progress: Double) {
        didSetRingProgress = progress
    }

    //swiftlint:disable:next large_tuple
    private(set) var didUpdateButtonImages: (image1Name: String, image2Name: String,
                                             image3Name: String, image4Name: String)?
    func updateButtonImages(image1Name: String, image2Name: String, image3Name: String, image4Name: String) {
        didUpdateButtonImages = (image1Name: image1Name, image2Name: image2Name,
                                 image3Name: image3Name, image4Name: image4Name)
    }

    private(set) var didAnimateLabel: (endValue: Double, animationDuration: Double)?
    func animateLabel(endValue: Double, animationDuration: Double) {
        didAnimateLabel = (endValue: endValue, animationDuration: animationDuration)
    }

    //swiftlint:disable:next large_tuple
    private(set) var didUpdateButtonSubtitles: (subtitle1: String, subtitle2: String,
                                                subtitle3: String, subtitle4: String)?
    func updateButtonSubtitles(subtitle1: String, subtitle2: String, subtitle3: String, subtitle4: String) {
        didUpdateButtonSubtitles = (subtitle1: subtitle1,
                                    subtitle2: subtitle2,
                                    subtitle3: subtitle3,
                                    subtitle4: subtitle4)
    }

    //swiftlint:disable:next large_tuple
    private(set) var didSetupGradientBars: (dailyGoal: Int, morningGoal: Int, afternoonGoal: Int, eveningGoal: Int)?
    func setupGradientBars(dailyGoal: Int, morningGoal: Int, afternoonGoal: Int, eveningGoal: Int) {
        didSetupGradientBars = (dailyGoal: dailyGoal, morningGoal: morningGoal,
                                afternoonGoal: afternoonGoal, eveningGoal: eveningGoal)
    }

    private(set) var didSetTodayGradientBarProgress: (total: Double, goal: Double)?
    func setTodayGradientBarProgress(total: Double, goal: Double) {
        didSetTodayGradientBarProgress = (total: total, goal: goal)
    }

    private(set) var didSetMorningGradientBarProgress: (total: Double, goal: Double)?
    func setMorningGradientBarProgress(total: Double, goal: Double) {
        didSetMorningGradientBarProgress = (total: total, goal: goal)
    }

    private(set) var didSetAfternoonGradientBarProgress: (total: Double, goal: Double)?
    func setAfternoonGradientBarProgress(total: Double, goal: Double) {
        didSetAfternoonGradientBarProgress = (total: total, goal: goal)
    }

    private(set) var didSetEveningGradientBarProgress: (total: Double, goal: Double)?
    func setEveningGradientBarProgress(total: Double, goal: Double) {
        didSetEveningGradientBarProgress = (total: total, goal: goal)
    }
}

final class MockCoreDataController: CoreDataControllerProtocol {
    var allEntries: [Drink] = []

    // Creates Core Data Controller in memory
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Drip")
        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    private(set) var didSaveContext: Bool = false
    func saveContext() {
        didSaveContext = true
    }

    private(set) var didFetchDrinks: Bool = false
    func fetchDrinks() {
        didFetchDrinks = true
    }

    //swiftlint:disable:next large_tuple
    private(set) var didAddDrink: (name: String, volume: Double, imageName: String, timeStamp: Date)?
    func addDrink(name: String, volume: Double, imageName: String, timeStamp: Date) {
        didAddDrink = (name: name, volume: volume, imageName: imageName, timeStamp: timeStamp)
    }

    // returns an array of mocked drinks.
    func fetchEntriesForDate(date: Date) -> [Drink] {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 9
        let morningDrink = Drink(context: context)
        morningDrink.name = "test"
        morningDrink.volume = 250
        morningDrink.imageName = "testImageName"
        morningDrink.timeStamp = Calendar.current.date(from: dateComponents)!

        dateComponents.hour = 15
        let afternoonDrink = Drink(context: context)
        afternoonDrink.name = "test"
        afternoonDrink.volume = 500
        afternoonDrink.imageName = "testImageName"
        afternoonDrink.timeStamp = Calendar.current.date(from: dateComponents)!

        dateComponents.hour = 20
        let eveningDrink = Drink(context: context)
        eveningDrink.name = "test"
        eveningDrink.volume = 1000
        eveningDrink.imageName = "testImageName"
        eveningDrink.timeStamp = Calendar.current.date(from: dateComponents)!

        return [morningDrink, afternoonDrink, eveningDrink]
    }

    private(set) var didDeleteEntry: Bool?
    func deleteEntry(entry: Drink) {
        didDeleteEntry = true
    }

}

class TodayPresenterTestCase: XCTestCase {
    private var sut: TodayPresenter!
    private var mockedView = MockTodayView()
    private var mockedCoreDataController = MockCoreDataController()

    override func setUp() {
        super.setUp()
        sut = TodayPresenter(view: mockedView)
        mockedView.coreDataController = mockedCoreDataController
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Today")
    }

    func test_whenOnViewDidLoadCalled_thenSetsUpRingView() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didSetupRingView!.startColor, .cyan)
        XCTAssertEqual(mockedView.didSetupRingView!.endColor, .blue)
        XCTAssertEqual(mockedView.didSetupRingView!.ringWidth, 30)
    }

    func test_whenOnViewDidLoadCalled_thenUpdateButtonImages() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image1Name, "waterbottle.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image2Name, "coffee.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image3Name, "cola.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image4Name, "add.svg")
    }

    func test_whenOnViewDidLoadCalled_thenUpdatesButtonSubtitles() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateButtonSubtitles?.subtitle1, "Water")
        XCTAssertEqual(mockedView.didUpdateButtonSubtitles?.subtitle2, "Coffee")
        XCTAssertEqual(mockedView.didUpdateButtonSubtitles?.subtitle3, "Soda")
        XCTAssertEqual(mockedView.didUpdateButtonSubtitles?.subtitle4, "Custom")
    }

    func test_whenOnViewDidLoadCalled_thenUSetsUpGradientBars() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didSetupGradientBars?.dailyGoal, 2000)
        XCTAssertEqual(mockedView.didSetupGradientBars?.morningGoal, 666)
        XCTAssertEqual(mockedView.didSetupGradientBars?.afternoonGoal, 666)
        XCTAssertEqual(mockedView.didSetupGradientBars?.eveningGoal, 666)
    }
    // MARK: - onViewDidAppear -

    func test_whenOnViewDidAppearCalled_thenSetsRingProgress() {
        // given & when
        sut.onViewDidAppear()

        //then
        XCTAssertTrue((0...1).contains(mockedView.didSetRingProgress!))
    }

    func test_whenOnViewDidAppearCalled_thenAnimateLabel() {
        // given & when
        sut.onViewDidAppear()

        // then
        XCTAssertTrue((0...100).contains(mockedView.didAnimateLabel!.endValue))
        XCTAssertEqual(mockedView.didAnimateLabel?.animationDuration, 2)
    }

    func test_whenOnViewDidAppearCalled_thenUpdatesGradientBars() {
        // given & when
        sut.onViewDidAppear()

        // then
        XCTAssertEqual(mockedView.didSetTodayGradientBarProgress?.total, 1750)
        XCTAssertEqual(mockedView.didSetTodayGradientBarProgress?.goal, 2000)
        XCTAssertEqual(mockedView.didSetMorningGradientBarProgress?.total, 250)
        XCTAssertEqual(mockedView.didSetMorningGradientBarProgress?.goal, 2000/3)
        XCTAssertEqual(mockedView.didSetAfternoonGradientBarProgress?.total, 500)
        XCTAssertEqual(mockedView.didSetAfternoonGradientBarProgress?.goal, 2000/3)
        XCTAssertEqual(mockedView.didSetEveningGradientBarProgress?.total, 1000)
        XCTAssertEqual(mockedView.didSetEveningGradientBarProgress?.goal, 2000/3)
    }

    // MARK: - onViewWillDisappear -

    func test_whenOnViewWillDisappear_thenSavesContext() {
        // given & when
        sut.onViewWillDisappear()

        // then
        XCTAssertTrue(mockedCoreDataController.didSaveContext)
    }

    // MARK: - Buttons -

    func test_OnDrinkButton1Tapped_thenSavesDrink1() {
        // given & when
        sut.onDrinkButton1Tapped()

        // then
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.name, "Water")
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.volume, 500)
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.imageName, "waterbottle.svg")
        XCTAssertTrue(Calendar.current.isDate(mockedCoreDataController.didAddDrink!.timeStamp, inSameDayAs: Date()))
    }

    func test_OnDrinkButton2Tapped_thenSavesDrink2() {
        // given & when
        sut.onDrinkButton2Tapped()

        // then
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.name, "Coffee")
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.volume, 250)
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.imageName, "coffee.svg")
        XCTAssertTrue(Calendar.current.isDate(mockedCoreDataController.didAddDrink!.timeStamp, inSameDayAs: Date()))
    }

    func test_OnDrinkButton3Tapped_thenSavesDrink3() {
        // given & when
        sut.onDrinkButton3Tapped()

        // then
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.name, "Cola")
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.volume, 330)
        XCTAssertEqual(mockedCoreDataController.didAddDrink?.imageName, "cola.svg")
        XCTAssertTrue(Calendar.current.isDate(mockedCoreDataController.didAddDrink!.timeStamp, inSameDayAs: Date()))
    }

}

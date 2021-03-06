import XCTest
import CoreData

@testable import Drip

final class MockTodayView: TodayViewProtocol {
    var coreDataController: CoreDataControllerProtocol! = CoreDataController.shared
    var userDefaultsController: UserDefaultsControllerProtocol!
    var healthKitController: HealthKitControllerProtocol!

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

    private(set) var didUpdateGreetingLabel: String?
    func updateGreetingLabel(text: String) {
        didUpdateGreetingLabel = text
    }
    private(set) var didSetOverviewTitles: (remainingText: String, goalText: String)?
    func setOverviewTitles(remainingText: String, goalText: String) {
        didSetOverviewTitles = (remainingText: remainingText, goalText: goalText)
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

class TodayPresenterTestCase: XCTestCase {
    private var sut: TodayPresenter!
    private var mockedView = MockTodayView()
    private var coreDataController = CoreDataController.shared
    private var mockedUserDefaultsController = MockUserDefaultsController()
    private var mockedHealthKitController = MockHealthKitController()

    override func setUp() {
        super.setUp()
        flushCoreData()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.healthKitController = mockedHealthKitController
        sut = TodayPresenter(view: mockedView)
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
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 9
        var timeStamp = Calendar.current.date(from: dateComponents)!
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 250,
                                          timeStamp: timeStamp)

        dateComponents.hour = 15
        timeStamp = Calendar.current.date(from: dateComponents)!
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 500,
                                          timeStamp: timeStamp)

        dateComponents.hour = 20
        timeStamp = Calendar.current.date(from: dateComponents)!
        coreDataController.addDrinkForDay(beverage: Beverage(name: "testDrink",
                                                             imageName: "testImage",
                                                             coefficient: 1),
                                          volume: 1000,
                                          timeStamp: timeStamp)
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

    func test_whenOnViewDidAppearCalled_thenSetsOverviewTitles() {
        // given & when
        sut.onViewDidAppear()

        // then
        XCTAssertEqual(mockedView.didSetOverviewTitles?.goalText, "2000ml")
        XCTAssertEqual(mockedView.didSetOverviewTitles?.remainingText, "2000ml")
    }

    // MARK: - updateGreetingLabel -

    func test_givenMorningTime_whenUpdateGreetingLabelCalled_thenUpdatesGreetingLabelCorrectly() {
        // given
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 9
        let timeStamp = Calendar.current.date(from: dateComponents)!

        // when
        sut.updateGreetingLabel(date: timeStamp)

        // then
        XCTAssertEqual(mockedView.didUpdateGreetingLabel!, "Good Morning, Tony Stark")
    }

    func test_givenAfternoonTime_whenUpdateGreetingLabelCalled_thenUpdatesGreetingLabelCorrectly() {
        // given
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 12
        let timeStamp = Calendar.current.date(from: dateComponents)!

        // when
        sut.updateGreetingLabel(date: timeStamp)

        // then
        XCTAssertEqual(mockedView.didUpdateGreetingLabel!, "Good Afternoon, Tony Stark")
    }

    func test_givenEveningTime_whenUpdateGreetingLabelCalled_thenUpdatesGreetingLabelCorrectly() {
        // given
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                             from: Date())

        dateComponents.hour = 18
        let timeStamp = Calendar.current.date(from: dateComponents)!

        // when
        sut.updateGreetingLabel(date: timeStamp)

        // then
        XCTAssertEqual(mockedView.didUpdateGreetingLabel!, "Good Evening, Tony Stark")
    }

    // MARK: - addDrinkTapped -
    func test_givenHealthKitEnabled_whenAddDrinkTappedCalled_thenHealthKitRecordsUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = true
        let drink = Beverage(name: "Water",
                             imageName: "waterbottle.svg",
                             coefficient: 1.0)
        let timeStamp = Date()

        // when
        sut.addDrinkTapped(beverage: drink,
                           volume: 500,
                           timeStamp: timeStamp)

        // then
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.amount, 500)
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.date, timeStamp)
    }

    func test_givenHealthKitDisabled_whenAddDrinkTappedCalled_thenHealthKitRecordsNotUpdated() {
        // given
        mockedUserDefaultsController.enabledHealthKit = false
        let drink = Beverage(name: "Water",
                             imageName: "waterbottle.svg",
                             coefficient: 1.0)
        let timeStamp = Date()

        // when
        sut.addDrinkTapped(beverage: drink,
                           volume: 500,
                           timeStamp: timeStamp)

        // then
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.amount, nil)
        XCTAssertEqual(mockedHealthKitController.waterAddedToHealthStore?.date, nil)
    }
}

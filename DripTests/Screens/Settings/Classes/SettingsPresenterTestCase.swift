import XCTest

@testable import Drip

final class MockSettingsView: SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol!

    var userDefaultsController: UserDefaultsControllerProtocol!
    var healthKitController: HealthKitControllerProtocol!

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

    private(set) var didCallChangeNameTapped: Bool = false
    func changeNameTapped() {
        didCallChangeNameTapped = true
    }

    private(set) var didCallInvalidName: Bool = false
    func invalidName() {
        didCallInvalidName = true
    }

    private(set) var didShowSafariWithUrl: URL?
    func showSafariWith(url: URL) {
        didShowSafariWithUrl = url
    }

    private(set) var didShowReviewPrompt: Bool = false
    func showReviewPrompt() {
        didShowReviewPrompt = true
    }

    private(set) var didShowWhatsNew: Bool = false
    func showWhatsNew() {
        didShowWhatsNew = true
    }
}

class SettingsPresenterTestCase: XCTestCase {
    private var sut: SettingsPresenter!
    private var mockedView = MockSettingsView()
    private var mockedUserDefaultsController = MockUserDefaultsController()
    private var mockedHealthKitController = MockHealthKitController()

    override func setUp() {
        super.setUp()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.healthKitController = mockedHealthKitController
        sut = SettingsPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Settings")
    }

    // MARK: - numberOfRowsInSection -

    func test_givenSection0_whenOnumberOfRowsInSectionCalled_thenReturnsCorrectValue() {
        // given
        let section = 0

        // when &then
        XCTAssertEqual(sut.numberOfRowsInSection(section), 6)
    }

    func test_givenSection1_whenOnumberOfRowsInSectionCalled_thenReturnsCorrectValue() {
        // given
        let section = 1

        // when &then
        XCTAssertEqual(sut.numberOfRowsInSection(section), 5)
    }

    // MARK: - getCellDataForIndexPath -

    func test_givenIndexPathSection0Row0_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 0, section: 0)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Name")
        XCTAssertEqual(cellData.imageName, "square.and.pencil")
        XCTAssertEqual(cellData.backgroundColour, .systemBlue)
    }

    func test_givenIndexPathSection0Row1_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 1, section: 0)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Goal")
        XCTAssertEqual(cellData.imageName, "slider.horizontal.3")
        XCTAssertEqual(cellData.backgroundColour, .systemIndigo)
    }

    func test_givenIndexPathSection0Row2_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 2, section: 0)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Favourites")
        XCTAssertEqual(cellData.imageName, "star")
        XCTAssertEqual(cellData.backgroundColour, .systemOrange)
    }

    func test_givenIndexPathSection0Row3_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 3, section: 0)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Drink Coefficients")
        XCTAssertEqual(cellData.imageName, "info.circle")
        XCTAssertEqual(cellData.backgroundColour, .systemTeal)
    }

    func test_givenIndexPathSection1Row0_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 0, section: 1)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "About")
        XCTAssertEqual(cellData.imageName, "at")
        XCTAssertEqual(cellData.backgroundColour, .systemBlue)
    }

    func test_givenIndexPathSection1Row1_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 1, section: 1)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "What's New")
        XCTAssertEqual(cellData.imageName, "wand.and.stars")
        XCTAssertEqual(cellData.backgroundColour, .systemIndigo)
    }

    func test_givenIndexPathSection1Row2_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 2, section: 1)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Thanks to")
        XCTAssertEqual(cellData.imageName, "gift")
        XCTAssertEqual(cellData.backgroundColour, .systemOrange)
    }

    func test_givenIndexPathSection1Row3_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 3, section: 1)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Privacy Policy")
        XCTAssertEqual(cellData.imageName, "hand.raised")
        XCTAssertEqual(cellData.backgroundColour, .systemGreen)
    }

    func test_givenIndexPathSection1Row4_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 4, section: 1)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Rate Drip")
        XCTAssertEqual(cellData.imageName, "heart.fill")
        XCTAssertEqual(cellData.backgroundColour, .systemRed)
    }

    func test_givenIndexOutOfRange_whenGetCellDataForIndexPathCalled_thenReturnsCorrectData() {
        // given
        let indexPath = IndexPath(row: 5, section: 5)

        // when
        let cellData = sut.getCellDataForIndexPath(indexPath: indexPath)

        // then
        XCTAssertEqual(cellData.title, "Name")
        XCTAssertEqual(cellData.imageName, "square.and.pencil")
        XCTAssertEqual(cellData.backgroundColour, .systemBlue)
    }

    // MARK: - didSelectRowAt -

    func test_givenIndexPathSection0Row0_whenDidSelectRowAtCalled_thenCallsChangeNameTapped() {
        // given
        let indexPath = IndexPath(row: 0, section: 0)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didCallChangeNameTapped)
    }

    func test_givenIndexPathSection0Row1_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 1, section: 0)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didPushViewController is SettingsDetailView)
        XCTAssertEqual((mockedView.didPushViewController as? SettingsDetailView)!.settingsType,
                       SettingsType.goal)
    }

    func test_givenIndexPathSection0Row2_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 2, section: 0)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didPushViewController is SettingsDetailView)
        XCTAssertEqual((mockedView.didPushViewController as? SettingsDetailView)!.settingsType,
                       SettingsType.favourite)
    }

    func test_givenIndexPathSection0Row3_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 3, section: 0)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didPushViewController is SettingsDetailView)
        XCTAssertEqual((mockedView.didPushViewController as? SettingsDetailView)!.settingsType,
                       SettingsType.coefficient)
    }

    func test_givenIndexPathSection1Row0_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 0, section: 1)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didPushViewController is SettingsDetailView)
        XCTAssertEqual((mockedView.didPushViewController as? SettingsDetailView)!.settingsType,
                       SettingsType.about)
    }

    func test_givenIndexPathSection1Row1_whenDidSelectRowAtCalled_thenDidShowWhatsNew() {
        // given
        let indexPath = IndexPath(row: 1, section: 1)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didShowWhatsNew)
    }

    func test_givenIndexPathSection1Row2_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 2, section: 1)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didPushViewController is SettingsDetailView)
        XCTAssertEqual((mockedView.didPushViewController as? SettingsDetailView)!.settingsType,
                       SettingsType.attribution)
    }

    func test_givenIndexPathSection1Row3_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 3, section: 1)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertEqual(mockedView.didShowSafariWithUrl?.absoluteString,
                       "https://dripmobile.app/privacy.html")
    }

    func test_givenIndexPathSection1Row4_whenDidSelectRowAtCalled_thenPushesCorrectView() {
        // given
        let indexPath = IndexPath(row: 4, section: 1)

        // when
        sut.didSelectRowAt(indexPath: indexPath)

        // then
        XCTAssertTrue(mockedView.didShowReviewPrompt)
    }

    // MARK: - fetchName -

    func test_givenMockUserDefaultsController_whenFetchNameCalled_thenReturnsMockName() {
        // when
        let name = sut.fetchName()

        // then
        XCTAssertEqual(name, "Tony Stark")
    }

    // MARK: - updateName -

    func test_givenValidName_whenUpdateNameCalled_thenSavesMockName() {
        // given
        let name = "Black Panther"

        // when
        sut.updateName(name: name)

        // then
        XCTAssertEqual(mockedUserDefaultsController.name, "Black Panther")
    }

    func test_givenEmptyName_whenUpdateNameCalled_thenCallsInvalidName() {
        // given
        let name = ""

        // when
        sut.updateName(name: name)

        // then
        XCTAssertTrue(mockedView.didCallInvalidName)
    }

    func test_given16CharacterName_whenUpdateNameCalled_thenCallsInvalidName() {
        // given
        let name = "1234567890123456"

        // when
        sut.updateName(name: name)

        // then
        XCTAssertTrue(mockedView.didCallInvalidName)
    }

    func test_givenNilName_whenUpdateNameCalled_thenCallsInvalidName() {
        // given
        let name: String? = nil

        // when
        sut.updateName(name: name)

        // then
        XCTAssertTrue(mockedView.didCallInvalidName)
    }

}

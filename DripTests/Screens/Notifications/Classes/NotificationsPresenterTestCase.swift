import XCTest

@testable import Drip

final class MockNotificationsView: NotificationsViewProtocol {
    var presenter: NotificationsPresenterProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
    var notificationController: LocalNotificationControllerProtocol!

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

    private(set) var didPresentViewController: UIViewController?
    func presentView(_ view: UIViewController) {
        didPresentViewController = view
    }

    private(set) var didUpdateReminderCountTitle: Int?
    func updateReminderCountTitle(count: Int) {
        didUpdateReminderCountTitle = count
    }

    private(set) var didSetupNotificationsView: (headingText: String, bodyText: String)?
    func setupNotificationsView(headingText: String, bodyText: String) {
        didSetupNotificationsView = (headingText: headingText, bodyText: bodyText)
    }

    private(set) var didSetPickerRow: Int?
    func setPickerRow(row: Int) {
        didSetPickerRow = row
    }

    private(set) var didReloadTableView: Bool = false
    func reloadTableView() {
        didReloadTableView = true
    }

    private(set) var didSetToggleStatus: Bool = false
    func setToggleStatus(isOn: Bool) {
        didSetToggleStatus = isOn
    }

    private(set) var didShowSettingsNotificationDialogue: Bool = false
    func showSettingsNotificationDialogue() {
        didShowSettingsNotificationDialogue = true
    }

    private(set) var didResetPicker: Bool = false
    func resetPicker() {
        didResetPicker = true
    }
}

class NotificationsPresenterTestCase: XCTestCase {
    private var sut: NotificationsPresenter!
    private var mockedView = MockNotificationsView()
    private var mockedUserDefaultsController = MockUserDefaultsController()
    private var mockedNotificationController = MockLocalNotificationController()

    override func setUp() {
        super.setUp()
        mockedView.userDefaultsController = mockedUserDefaultsController
        mockedView.notificationController = mockedNotificationController
        sut = NotificationsPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Notifications")
    }

    // MARK: - checkNotificationStatus -

    func test_givenAuthorisedStatusAndNotifsEnabled_whenCheckNotificationStatusCalled_thenUpdatesToggleStatus() {
        // given
        mockedNotificationController.authStatus = .authorized
        mockedUserDefaultsController.enabledNotifications = true
        let expectation = self.expectation(description: "switch toggle test")

        DispatchQueue.main.async {
            // when
            self.sut.checkNotificationStatus()
            expectation.fulfill()

        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertTrue(self.mockedView.didSetToggleStatus)
    }

    func test_givenAuthorisedStatusAndNotifsDisabled_whenCheckNotificationStatusCalled_thenUpdatesToggleStatus() {
        // given
        mockedNotificationController.authStatus = .authorized
        mockedUserDefaultsController.enabledNotifications = false
        let expectation = self.expectation(description: "check notif test")

        DispatchQueue.main.async {
            // when
            self.sut.checkNotificationStatus()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertFalse(self.mockedView.didSetToggleStatus)
    }

    func test_givenProvisionalStatusAndNotifsEnabled_whenCheckNotificationStatusCalled_thenUpdatesToggleStatus() {
        // given
        mockedNotificationController.authStatus = .provisional
        mockedUserDefaultsController.enabledNotifications = true
        let expectation = self.expectation(description: "check notif test")

        DispatchQueue.main.async {
            // when
            self.sut.checkNotificationStatus()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertTrue(self.mockedView.didSetToggleStatus)
    }

    func test_givenProvisionalStatusAndNotifsDisabled_whenCheckNotificationStatusCalled_thenUpdatesToggleStatus() {
        // given
        mockedNotificationController.authStatus = .provisional
        mockedUserDefaultsController.enabledNotifications = false
        let expectation = self.expectation(description: "check notif test")

        DispatchQueue.main.async {
            // when
            self.sut.checkNotificationStatus()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertFalse(self.mockedView.didSetToggleStatus)
    }

    func test_givenDeniedAuthStatus_whenCheckNotificationStatusCalled_thenUpdatesRelatedValues() {
        // given
        mockedNotificationController.authStatus = .denied
        let expectation = self.expectation(description: "check notif test")

        DispatchQueue.main.async {
            // when
            self.sut.checkNotificationStatus()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertFalse(self.mockedView.didSetToggleStatus)
        XCTAssertFalse(self.mockedUserDefaultsController.enabledNotifications)
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
        XCTAssertTrue(self.mockedView.didResetPicker)
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
        XCTAssertTrue(self.mockedView.didResetPicker)
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
        XCTAssertTrue(self.mockedView.didResetPicker)
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
    }

    func test_whenOnSwitchToggleCalledWithFalse_thenCallsCorrectFunctions() {
        // when
        sut.onSwitchToggle(isOn: false)

        // then
        XCTAssertFalse(mockedView.didSetToggleStatus)
        XCTAssertFalse(mockedUserDefaultsController.enabledNotifications)
    }

    // MARK: - fetchNotifications -

    func test_givenNoPendingNotifications_whenFetchNotificationsCalled_thenCallsUIWithCorrectValues() {
        // given
        mockedNotificationController.mockedNotifications = []
        let expectation = self.expectation(description: "Fetch Notifications Test")

        DispatchQueue.main.async {
            // when
            self.sut.fetchNotifications()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertEqual(self.mockedView.didUpdateReminderCountTitle, 0)
        XCTAssertTrue(self.mockedView.didReloadTableView)
        XCTAssertEqual(self.mockedView.didSetPickerRow, 0)
    }

    func test_givenOnePendingNotifications_whenFetchNotificationsCalled_thenCallsUIMethods() {
        // given
        mockedNotificationController.mockedNotifications =
            [Drip.Notification(id: "1",
                               title: "test",
                               body: "test",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 00, minute: 01),
                               sound: true)]
        let expectation = self.expectation(description: "Fetch Notifications Test")

        DispatchQueue.main.async {
            // when
            self.sut.fetchNotifications()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        // then
        XCTAssertEqual(self.mockedView.didUpdateReminderCountTitle, 1)
        XCTAssertTrue(self.mockedView.didReloadTableView)
        XCTAssertEqual(self.mockedView.didSetPickerRow, 0)
    }

    // MARK: - timeStampForRow -

    func test_givenNoNotifications_whenTimeStampForRowCalled_ThenReturnsEmptyString() {
        // given
        mockedNotificationController.notifications = []

        // when
        let timeStampString = sut.timeStampForRow(row: 0)

        // then
        XCTAssertEqual(timeStampString, "")
    }

    func test_given1Notification_whenTimeStampForRow0Called_ThenCorrectTimeStamp() {
        // given
        mockedNotificationController.notifications =
            [Drip.Notification(id: "1",
                               title: "test",
                               body: "test",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 13, minute: 10),
                               sound: true)]

        // when
        let timeStampString = sut.timeStampForRow(row: 0)

        // then
        XCTAssertEqual(timeStampString, "13:10 PM")
    }

    // MARK: - setReminderCount -

    // MARK: - amendReminder -

    // MARK: - disableNotifications -

    // MARK: - enableNotifications -

    // MARK: - numberOfRowsInSection -

    // MARK: - getNotificationInfoForRow -
}

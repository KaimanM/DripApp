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

    func test_given0Reminders_whenSetReminderCountTo3_thenAdds3RemindersAndReloadTableView() {
        // given
        mockedNotificationController.notifications = []

        // when
        sut.setReminderCount(to: 3)

        // then
        XCTAssertEqual(mockedNotificationController.notifications.count, 3)
        XCTAssertEqual(mockedNotificationController.notifications[0].id, "1")
        XCTAssertEqual(mockedNotificationController.notifications[1].id, "2")
        XCTAssertEqual(mockedNotificationController.notifications[2].id, "3")
        XCTAssertTrue(mockedView.didReloadTableView)
    }

    func test_given1Reminders_whenSetReminderCountTo0_thenCallsDidRemovePendingNotificationsWithIdAndReloadTableView() {
        // given
        mockedNotificationController.notifications =
            [Drip.Notification(id: "1", title: "Let's stay hydrated!",
                               body: "Let's have a drink!",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 00, minute: 01),
                               sound: true)]

        // when
        sut.setReminderCount(to: 0)

        // then
        XCTAssertTrue(mockedNotificationController.didRemovePendingNotificationWithId)
        XCTAssertTrue(mockedView.didReloadTableView)
    }

    // MARK: - amendReminder -

    func test_givenAReminderWithId1_whenAmendReminderCalled_thenOverwritesOldReminder() {
        // given
        mockedNotificationController.notifications =
            [Drip.Notification(id: "1", title: "Let's stay hydrated!",
                               body: "Let's have a drink!",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 00, minute: 01),
                               sound: true)]

        // when
        sut.amendReminder(notification: Drip.Notification(id: "1",
                                                          title: "Let's stay hydrated!",
                                                          body: "Test Replacement",
                                                          timeStamp: DateComponents(calendar: Calendar.current,
                                                                                    hour: 12, minute: 30),
                                                          sound: false))

        // then
        XCTAssertEqual(mockedNotificationController.notifications[0].title, "Let's stay hydrated!")
        XCTAssertEqual(mockedNotificationController.notifications[0].body, "Test Replacement")
        XCTAssertEqual(mockedNotificationController.notifications[0].timeStamp,
                       DateComponents(calendar: Calendar.current,
                                      hour: 12, minute: 30))
        XCTAssertEqual(mockedNotificationController.notifications[0].sound, false)
    }

    func test_givenAReminderWithId1_whenAmendReminderCalledWithId2_thenDoesNotOverwriteOldReminder() {
        // given
        mockedNotificationController.notifications =
            [Drip.Notification(id: "1", title: "Let's stay hydrated!",
                               body: "Let's have a drink!",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 00, minute: 01),
                               sound: true)]

        // when
        sut.amendReminder(notification: Drip.Notification(id: "2",
                                                          title: "Let's stay hydrated!",
                                                          body: "Test Replacement",
                                                          timeStamp: DateComponents(calendar: Calendar.current,
                                                                                    hour: 12, minute: 30),
                                                          sound: false))

        // then
        XCTAssertEqual(mockedNotificationController.notifications[0].title, "Let's stay hydrated!")
        XCTAssertEqual(mockedNotificationController.notifications[0].body, "Let's have a drink!")
        XCTAssertEqual(mockedNotificationController.notifications[0].timeStamp,
                       DateComponents(calendar: Calendar.current,
                                                 hour: 00, minute: 01))
        XCTAssertEqual(mockedNotificationController.notifications[0].sound, true)
    }

    // MARK: - disableNotifications -

    func test_whenDisableNotificationCalled_thenCallsCorrectFunctions() {
        // when
        sut.disableNotifications()

        // then
        XCTAssertTrue(mockedNotificationController.didRemoveAllPendingNotifications)
        XCTAssertTrue(mockedView.didReloadTableView)
    }

    // MARK: - enableNotifications -

    func test_whenEnableNotificationCalled_thenCallsCorrectFunctions() {
        // when
        sut.enableNotifications()

        // then
        XCTAssertTrue(mockedNotificationController.didSetupDefaultNotifications)
        XCTAssertTrue(mockedView.didReloadTableView)
    }

    // MARK: - numberOfRowsInSection -

    func test_given0Notifications_whenNumberOfRowsInSectionCalled_thenReturnsCorrectInt() {
        // given
        mockedNotificationController.notifications = []

        // when
        let rows = sut.numberOfRowsInSection()

        // then
        XCTAssertEqual(rows, 0)
    }

    func test_given3Notifications_whenNumberOfRowsInSectionCalled_thenReturnsCorrectInt() {
        // given
        mockedNotificationController.notifications =
            [Drip.Notification(id: "1", title: "Let's stay hydrated!",
                               body: "Let's have a drink!",
                               timeStamp: DateComponents(calendar: Calendar.current,
                                                         hour: 00, minute: 01),
                               sound: true),
             Drip.Notification(id: "2", title: "Let's stay hydrated!",
                                body: "Let's have a drink!",
                                timeStamp: DateComponents(calendar: Calendar.current,
                                                          hour: 00, minute: 01),
                                sound: true),
             Drip.Notification(id: "3", title: "Let's stay hydrated!",
                                body: "Let's have a drink!",
                                timeStamp: DateComponents(calendar: Calendar.current,
                                                          hour: 00, minute: 01),
                                sound: true)
            ]

        // when
        let rows = sut.numberOfRowsInSection()

        // then
        XCTAssertEqual(rows, 3)
    }

    // MARK: - getNotificationInfoForRow -

    func test_givenANotification_whenGetNotificationInfoForRowCalled_thenReturnsCorrectNotificationObject() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 00, minute: 01),
                                             sound: true)
        mockedNotificationController.notifications.append(notification)

        // when
        let notif = sut.getNotificationInfoForRow(row: 0)

        //then
        XCTAssertEqual(notif.id, "1")
        XCTAssertEqual(notif.title, "test")
        XCTAssertEqual(notif.body, "test")
        XCTAssertEqual(notif.timeStamp, DateComponents(calendar: Calendar.current,
                                                       hour: 00, minute: 01))
        XCTAssertEqual(notif.sound, true)
    }

    func test_givenNoNotifications_whenGetNotificationInfoForRowCalled_thenReturnsErrorNotificationObject() {
        // given
        mockedNotificationController.notifications = []

        // when
        let notif = sut.getNotificationInfoForRow(row: 0)

        //then
        XCTAssertEqual(notif.id, "-1")
        XCTAssertEqual(notif.title, "Error")
        XCTAssertEqual(notif.body, "Error")
        XCTAssertEqual(notif.timeStamp, DateComponents(calendar: Calendar.current,
                                                       hour: 00, minute: 00))
        XCTAssertEqual(notif.sound, false)
    }
    // swiftlint:disable:next file_length
}

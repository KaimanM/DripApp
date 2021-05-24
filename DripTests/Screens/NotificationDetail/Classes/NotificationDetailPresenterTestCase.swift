import XCTest

@testable import Drip

final class MockNotificationDetailView: NotificationDetailViewProtocol {
    var presenter: NotificationDetailPresenterProtocol!

    var notification: Drip.Notification!

    private(set) var didUpdatePickerDate: Date?
    func updatePickerDate(date: Date) {
        didUpdatePickerDate = date
    }

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

}

class NotificationDetailPresenterTestCase: XCTestCase {
    private var sut: NotificationDetailPresenter!
    private var mockedView = MockNotificationDetailView()

    override func setUp() {
        super.setUp()
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: true)
        mockedView.notification = notification
        sut = NotificationDetailPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Edit Reminder")
    }

    func test_whenOnViewDidLoadCalled_thenDidUpdatePickerDateNotNil() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertNotNil(mockedView.didUpdatePickerDate)
    }

    // MARK: - setupPickerDate -

    func test_whenSetupPickerDateCalled_thenUpdatesPickerDate() {
        // given & when
        sut.setupPickerDate()

        // then
        XCTAssertEqual(mockedView.didUpdatePickerDate, DateComponents(calendar: Calendar.current,
                                                                      hour: 12, minute: 30).date)
    }

    // MARK: - isSoundEnabled -

    func test_givenNotificationWithSound_whenIsSoundEnabledCalled_thenReturnsCorrectValue() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: true)
        mockedView.notification = notification

        // when
        let enabled = sut.isSoundEnabled()

        // then
        XCTAssertTrue(enabled)
    }

    func test_givenNotificationWithoutSound_whenIsSoundEnabledCalled_thenReturnsCorrectValue() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: false)
        mockedView.notification = notification

        // when
        let enabled = sut.isSoundEnabled()

        // then
        XCTAssertFalse(enabled)
    }

    // MARK: - updateBody -

    func test_givenANotification_whenUpdateBodyCalled_thenAmendsBody() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: false)
        mockedView.notification = notification

        // when
        sut.updateBody(body: "Tony Stark is cool!")

        // then
        XCTAssertEqual(mockedView.notification.body, "Tony Stark is cool!")
    }

    // MARK: - updateTimeStamp -

    func test_givenANotification_whenUpdateTimeStampCalled_thenAmendsTimeStamp() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: false)
        mockedView.notification = notification

        // when
        let newTimeStamp = DateComponents(calendar: Calendar.current,
                                          hour: 20, minute: 21).date
        sut.updateTimeStamp(date: newTimeStamp!)

        // then
        XCTAssertEqual(mockedView.notification.timeStamp, DateComponents(calendar: Calendar.current,
                                                                         hour: 20, minute: 21))
    }

    // MARK: - enableSound -

    func test_givenANotificationWithSoundOff_whenEnableSoundCalled_thenAmendsSoundSetting() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: false)
        mockedView.notification = notification

        // when
        sut.enableSound(enabled: true)

        // then
        XCTAssertTrue(mockedView.notification.sound)
    }

    func test_givenANotificationWithSoundOn_whenEnableSoundCalled_thenAmendsSoundSetting() {
        // given
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 12, minute: 30),
                                             sound: true)
        mockedView.notification = notification

        // when
        sut.enableSound(enabled: false)

        // then
        XCTAssertFalse(mockedView.notification.sound)
    }

    // MARK: - numberOfRowsInSection -

    func test_whenNumberOfRowsInSectionCalled_thenReturns2() {
        // when
        XCTAssertEqual(sut.numberOfRowsInSection(), 2)
    }

    // MARK: - titleForRowAt -

    func test_whentitleForRowAt0Called_thenReturnsCorrectString() {
        // when
        XCTAssertEqual(sut.titleForRowAt(row: 0), "Message")
        XCTAssertEqual(sut.titleForRowAt(row: 1), "Sound")
    }

}

import XCTest

@testable import Drip

class NotificationDetailScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let notification = Drip.Notification(id: "1",
                                             title: "test",
                                             body: "test",
                                             timeStamp: DateComponents(calendar: Calendar.current,
                                                                       hour: 00, minute: 00),
                                             sound: false)
        let view = NotificationDetailScreenBuilder(notification: notification).build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

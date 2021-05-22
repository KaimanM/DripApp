import XCTest

@testable import Drip

class NotificationsScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = NotificationsScreenBuilder(userDefaultsController:
                                                MockUserDefaultsController()).build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

import XCTest

@testable import Drip

class TodayScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = TodayScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

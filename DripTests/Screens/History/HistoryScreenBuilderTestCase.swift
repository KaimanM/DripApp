import XCTest

@testable import Drip

class HistoryScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = HistoryScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

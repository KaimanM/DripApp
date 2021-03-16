import XCTest

@testable import Drip

class TrendsScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = TrendsScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

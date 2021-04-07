import XCTest

@testable import Drip

class AwardsScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = AwardsScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

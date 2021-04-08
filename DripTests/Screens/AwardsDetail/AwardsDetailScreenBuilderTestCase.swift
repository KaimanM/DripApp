import XCTest

@testable import Drip

class AwardsDetailScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = AwardsDetailScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

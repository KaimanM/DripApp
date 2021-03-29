import XCTest

@testable import Drip

class OnboardingPagesScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = OnboardingPagesScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

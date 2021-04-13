import XCTest

@testable import Drip

class SettingsScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = SettingsScreenBuilder().build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

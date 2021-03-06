import XCTest

@testable import Drip

class SettingsDetailScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let view = SettingsDetailScreenBuilder(type: .about,
                                               userDefaultsController: MockUserDefaultsController(),
                                               healthKitController: MockHealthKitController()).build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

import XCTest

@testable import Drip

class WhatsNewScreenBuilderTestCase: XCTestCase {
    func test_whenBuildCalled_thenViewPresenterRelationEstablished() {
        // given & when
        let featureItems = [WhatsNewItem(title: "test", subtitle: "test", image: UIImage(systemName: "star")!)]
        let view = WhatsNewScreenBuilder(featureItems: featureItems).build()

        // then
        XCTAssertTrue(view.presenter.view! === view)
    }
}

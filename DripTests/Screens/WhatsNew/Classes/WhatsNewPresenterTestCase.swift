import XCTest

@testable import Drip

final class MockWhatsNewView: WhatsNewViewProtocol {
    var featureItems: [WhatsNewItem] = []

    var presenter: WhatsNewPresenterProtocol!
}

class WhatsNewPresenterTestCase: XCTestCase {
    private var sut: WhatsNewPresenter!
    private var mockedView = MockWhatsNewView()

    override func setUp() {
        super.setUp()
        let featureItems = [WhatsNewItem(title: "test", subtitle: "test", image: UIImage(systemName: "star")!)]
        mockedView.featureItems = featureItems
        sut = WhatsNewPresenter(view: mockedView)
    }

    // MARK: - numberOfRowsInSection -

    func test_whenNumberOfRowsInSectionCalled_thenReturnsCorrectNumber() {
        // when & then
        XCTAssertEqual(sut.numberOfRowsInSection(), 1)
    }

    func test_givenNoFeatureItems_whenNumberOfRowsInSectionCalled_thenReturns0() {
        //given
        mockedView.featureItems = []

        // when & then
        XCTAssertEqual(sut.numberOfRowsInSection(), 0)
    }

    // MARK: - cellForRowAt -
    func test_whenCellForRowAtCalled_thenReturnsCorrectData() {
        // when
        let whatsNewItem = sut.cellForRowAt(row: 0)

        // then
        XCTAssertEqual(whatsNewItem?.title, "test")
        XCTAssertEqual(whatsNewItem?.subtitle, "test")
        XCTAssertEqual(whatsNewItem?.image, UIImage(systemName: "star")!)
    }

    func test_givenNoFeatureItems_whenCellForRowAtCalled_thenReturnsCorrectData() {
        // given
        mockedView.featureItems = []

        // when
        let whatsNewItem: WhatsNewItem? = sut.cellForRowAt(row: 0)

        // then
        XCTAssertNil(whatsNewItem)
    }
}

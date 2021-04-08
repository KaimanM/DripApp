import XCTest
import CoreData

@testable import Drip

final class MockAwardsDetailView: AwardsDetailViewProtocol {
    var presenter: AwardsDetailPresenterProtocol!

    var dataSource: AwardsDetailDataSourceProtocol?

    var timeStamp: Date?

    // swiftlint:disable:next large_tuple
    private(set) var didUpdateLabels: (awardName: String, awardBody: String, timeStamp: String)?
    func updateLabels(awardName: String, awardBody: String, timeStamp: String) {
        didUpdateLabels = (awardName: awardName, awardBody: awardBody, timeStamp: timeStamp)
    }

    private(set) var didUpdateImage: String?
    func updateImage(imageName: String) {
        didUpdateImage = imageName
    }
}

private struct MockAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = -1
    var imageName = "test.pdf"
    var awardName = "testAward"
    var awardBody = "testBody"
}

class AwardsDetailPresenterTestCase: XCTestCase {
    private var sut: AwardsDetailPresenter!
    private var mockedView = MockAwardsDetailView()

    override func setUp() {
        super.setUp()
        sut = AwardsDetailPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_givenLockedDataSourceNoTimeStamp_whenOnViewDidLoadCalled_thenCallsDidUpdateLabelsAndImages() {
        // given
        mockedView.dataSource = MockAwardDataSource()

        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateLabels?.awardName, "testAward")
        XCTAssertEqual(mockedView.didUpdateLabels?.awardBody, "testBody")
        XCTAssertEqual(mockedView.didUpdateLabels?.timeStamp, "")
        XCTAssertEqual(mockedView.didUpdateImage, "test.pdf")
    }

    func test_givenTenDrinksDataSourceWithTimeStamp_whenOnViewDidLoadCalled_thenCallsDidUpdateLabelsAndImages() {
        // given
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        mockedView.dataSource = MockAwardDataSource()
        mockedView.timeStamp = date
        // when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateLabels?.awardName, "testAward")
        XCTAssertEqual(mockedView.didUpdateLabels?.awardBody, "testBody")
        XCTAssertEqual(mockedView.didUpdateLabels?.timeStamp, "Unlocked on \(formatter.string(from: date))")
        XCTAssertEqual(mockedView.didUpdateImage, "test.pdf")
    }
}

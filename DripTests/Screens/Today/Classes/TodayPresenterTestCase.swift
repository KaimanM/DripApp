import XCTest

@testable import Drip

final class MockTodayView: TodayViewProtocol {

    var presenter: TodayPresenterProtocol!

    private(set) var didPresentViewController: UIViewController?
    func presentView(_ view: UIViewController) {
        didPresentViewController = view
    }

    private(set) var didShowViewController: UIViewController?
    func showView(_ view: UIViewController) {
        didShowViewController = view
    }

    private(set) var didUpdateTitle: String?
    func updateTitle(title: String) {
        didUpdateTitle = title
    }

    // swiftlint:disable:next large_tuple
    private(set) var didSetupRingView: (startColor: UIColor, endColor: UIColor, ringWidth: CGFloat)?
    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        didSetupRingView = (startColor: startColor, endColor: endColor, ringWidth: ringWidth)
    }

    private(set) var didSetRingProgress: Double?
    func setRingProgress(progress: Double) {
        didSetRingProgress = progress
    }

    //swiftlint:disable:next large_tuple
    private(set) var didUpdateButtonImages: (image1Name: String,
                                             image2Name: String,
                                             image3Name: String,
                                             image4Name: String)?
    func updateButtonImages(image1Name: String, image2Name: String, image3Name: String, image4Name: String) {
        didUpdateButtonImages = (image1Name: image1Name,
                                 image2Name: image2Name,
                                 image3Name: image3Name,
                                 image4Name: image4Name)
    }

    private(set) var didAnimateLabel: (endValue: Double, animationDuration: Double)?
    func animateLabel(endValue: Double, animationDuration: Double) {
        didAnimateLabel = (endValue: endValue, animationDuration: animationDuration)
    }
}

class TodayPresenterTestCase: XCTestCase {
    private var sut: TodayPresenter!
    private var mockedView = MockTodayView()

    override func setUp() {
        super.setUp()
        sut = TodayPresenter(view: mockedView)
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Today")
    }

    func test_whenOnViewDidLoadCalled_thenSetsUpRingView() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didSetupRingView!.startColor, .cyan)
        XCTAssertEqual(mockedView.didSetupRingView!.endColor, .blue)
        XCTAssertEqual(mockedView.didSetupRingView!.ringWidth, 30)
    }

    func test_whenOnViewDidLoadCalled_thenUpdateButtonImages() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image1Name, "waterbottle.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image2Name, "coffee.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image3Name, "cola.svg")
        XCTAssertEqual(mockedView.didUpdateButtonImages?.image4Name, "add.svg")
    }

    // MARK: - onViewDidAppear -

    func test_whenOnViewDidAppearCalled_thenSetsRingProgress() {
        // given & when
        sut.onViewDidAppear()

        //then
        XCTAssertTrue((0...1).contains(mockedView.didSetRingProgress!))
    }

    func test_whenOnViewDidAppearCalled_thenAnimateLabel() {
        // given & when
        sut.onViewDidAppear()

        // then
        XCTAssertTrue((0...100).contains(mockedView.didAnimateLabel!.endValue))
        XCTAssertEqual(mockedView.didAnimateLabel?.animationDuration, 2)
    }

}

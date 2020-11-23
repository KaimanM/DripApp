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

    // MARK: - onViewDidAppear -

    func test_whenOnViewDidAppearCalled_thenSetsRingProgress() {
        // given & when
        sut.onViewDidAppear()

        //then
        XCTAssertTrue(mockedView.didSetRingProgress! >= 0 || mockedView.didSetRingProgress! <= 1)
    }

}

import XCTest
import CoreData

@testable import Drip

final class MockTrendsView: TrendsViewProtocol {
    var presenter: TrendsPresenterProtocol!

    var coreDataController: CoreDataControllerProtocol! = CoreDataController.shared
    var userDefaultsController: UserDefaultsControllerProtocol! = UserDefaultsController.shared

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

    private(set) var didCallReloadData: Bool = false
    func reloadData() {
        didCallReloadData = true
    }

}

class TrendsPresenterTestCase: XCTestCase {
    private var sut: TrendsPresenter!
    private var mockedView = MockTrendsView()
    private var coreDataController = CoreDataController.shared

    override func setUp() {
        super.setUp()
        flushCoreData()
        sut = TrendsPresenter(view: mockedView)
    }

    func flushCoreData() {
        for entry in coreDataController.fetchDrinks(from: nil) {
            coreDataController.deleteEntry(entry: entry)
        }
    }

    // MARK: - onViewDidLoad -

    func test_whenOnViewDidLoadCalled_thenUpdatesTitle() {
        // given & when
        sut.onViewDidLoad()

        // then
        XCTAssertEqual(mockedView.didUpdateTitle!, "Trends")
    }

    // MARK: - onViewDidAppear -

//    func test_given0DrinksInCoreData_whenOnViewDidAppearCalled_thenFetchesDrinks() {
//        // given & when
//        sut.onViewDidAppear()
//
//        // then
//        XCTAssertEqual(coreDataController.allEntries.count, 0)
//    }

//    func test_given1DrinkInCoreData_whenOnViewDidAppearCalled_thenFetchesDrinks() {
//        // given
//        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
//
//        // when
//        sut.onViewDidAppear()
//
//        // then
//        XCTAssertEqual(coreDataController.allEntries.count, 1)
//    }

    func test_givenDidLoadDataIsFalse_whenOnViewDidAppearCalled_thenSetsToTrue() {
        // given
        sut.didLoadData = false

        // when
        sut.onViewDidAppear()

        // then
        XCTAssertTrue(sut.didLoadData)
    }

    func test_whenOnViewDidAppearCalled_thenReloadsDataInView() {
        // when
        sut.onViewDidAppear()

        // then
        XCTAssertTrue(mockedView.didCallReloadData)
    }

    // MARK: - Collection View -

    func test_whenGetSectionCountCalled_thenReturnsCorrectNumberOfSections() {
        // when
        XCTAssertEqual(sut.getSectionCount(), 3)
    }

    func test_whenGetSectionHeaderCalled_thenReturnsCorrectHeaderForIndex() {
        // when
        XCTAssertEqual(sut.getSectionHeader(for: 0), "All Time")
        XCTAssertEqual(sut.getSectionHeader(for: 1), "Last 7 days")
        XCTAssertEqual(sut.getSectionHeader(for: 2), "Last 30 days")
    }

    func test_whenGetNumberOfItemsInSectionCalled_thenReturnsCorrectNumberOfItems() {
        // when
        XCTAssertEqual(sut.getNumberOfItemsInSection(for: 0), 8)
        XCTAssertEqual(sut.getNumberOfItemsInSection(for: 1), 4)
        XCTAssertEqual(sut.getNumberOfItemsInSection(for: 2), 4)
    }

    func test_whenGetNumberOfItemsInSectionCalledForOutOfRangeIndex_thenReturnsZero() {
        // when
        XCTAssertEqual(sut.getNumberOfItemsInSection(for: 5), 0)
    }

    func test_whenGetTitleForCellIsCalled_thenReturnsCorrectTitle() {
        // when
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 0), "Average Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 1), "Average Daily")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 2), "Best Day")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 3), "Worst Day")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 4), "Current Streak")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 5), "Best Streak")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 6), "Favourite Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 0, row: 7), "Daily Drinks")

        XCTAssertEqual(sut.getTitleForCell(section: 1, row: 0), "Average Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 1, row: 1), "Average Day")
        XCTAssertEqual(sut.getTitleForCell(section: 1, row: 2), "Favourite Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 1, row: 3), "Daily Drinks")

        XCTAssertEqual(sut.getTitleForCell(section: 2, row: 0), "Average Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 2, row: 1), "Average Day")
        XCTAssertEqual(sut.getTitleForCell(section: 2, row: 2), "Favourite Drink")
        XCTAssertEqual(sut.getTitleForCell(section: 2, row: 3), "Daily Drinks")
    }

    func test_whenGetDataForCellCalledWithSection0Row0_thenReturnsAvgDrinkData() {
        // given two drinks of 250ml & 350ml
        mockedView.coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        mockedView.coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        mockedView.coreDataController.saveContext()
        sut.didLoadData = true

        print(mockedView.coreDataController.averageDrink(from: nil))

        // then average is 300ml
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 0), "300ml")
    }

    func test_whenGetDataForCellCalledWithSection0Row1_thenReturnsAvgDailyData() {
        // given two drinks of 250ml & 350ml
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.saveContext()
        sut.didLoadData = true

        // then daily average of 1 day is 600ml
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 1), "600ml")
    }

    func test_whenGetDataForCellCalledWithSection0Row2_thenReturnsBestDayData() {
        // given
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 2), "600ml")
    }

    func test_whenGetDataForCellCalledWithSection0Row3_thenReturnsWorstDayData() {
        // given
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 3), "500ml")
    }

    func test_whenGetDataForCellCalledWithSection0Row4_thenReturnsCurrentStreakData() {
        // given
        for day in -4 ... -1 {
            coreDataController.addDrinkForDay(name: "test", volume: 3000, imageName: "test",
                                        timeStamp: Date().addingTimeInterval(TimeInterval(day*24*60*60)))
        }
        coreDataController.addDrinkForDay(name: "test", volume: 3000, imageName: "test", timeStamp: Date())
        sut.populateArrangedDays()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 4), "5 days")
    }

    func test_whenGetDataForCellCalledWithSection0Row5_thenReturnsBestStreakData() {
        // given
        for day in -4 ... -1 {
            coreDataController.addDrinkForDay(name: "test", volume: 3000, imageName: "test",
                                        timeStamp: Date().addingTimeInterval(TimeInterval(day*24*60*60)))
        }
        coreDataController.addDrinkForDay(name: "test", volume: 500, imageName: "test", timeStamp: Date())
        sut.populateArrangedDays()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 5), "4 days")
    }

    func test_whenGetDataForCellCalledWithSection0Row6_thenReturnsFavDrinkData() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 6), "water")
    }

    func test_whenGetDataForCellCalledWithSection0Row7_thenReturnsDailyDrinkData() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-2*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 0, row: 7), "1.0 drinks")
    }

    func test_whenGetDataForCellCalledWithSection1Row0_thenReturnsAvgDrinkData7Days() {
        // given two drinks of 250ml & 350ml today and another drink 8 days ago
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then average is for 7 days 300ml
        XCTAssertEqual(sut.getDataForCell(section: 1, row: 0), "300ml")
    }

    func test_whenGetDataForCellCalledWithSection1Row1_thenReturnsAvgDailyData7Days() {
        // given two drinks of 250ml & 350ml today and another drink 8 days ago
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then daily average of 1 day is 600ml
        XCTAssertEqual(sut.getDataForCell(section: 1, row: 1), "600ml")
    }

    func test_whenGetDataForCellCalledWithSection1Row2_thenReturnsFavDrinkData7Days() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 1, row: 2), "water")
    }

    func test_whenGetDataForCellCalledWithSection1Row3_thenReturnsDailyDrinkData7days() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-2*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 1, row: 3), "1.0 drinks")
    }

    func test_whenGetDataForCellCalledWithSection2Row0_thenReturnsAvgDrinkData30Days() {
        // given
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 300, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        // this drink is over 30 days ago so shouldnt affect avg of 300
        coreDataController.addDrinkForDay(name: "test", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-31*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then average is for 7 days 300ml
        XCTAssertEqual(sut.getDataForCell(section: 2, row: 0), "300ml")
    }

    func test_whenGetDataForCellCalledWithSection2Row1_thenReturnsAvgDailyData30Days() {
        // given two drinks of 250ml & 350ml today and another drink 8 days ago
        coreDataController.addDrinkForDay(name: "test", volume: 250, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 350, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "test", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        // this drink is over 30 days ago so shouldnt affect avg daily of 800ml
        coreDataController.addDrinkForDay(name: "test", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-31*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then daily average of 1 day is 600ml
        XCTAssertEqual(sut.getDataForCell(section: 2, row: 1), "800ml")
    }

    func test_whenGetDataForCellCalledWithSection2Row2_thenReturnsFavDrinkData30Days() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-8*24*60*60))
        coreDataController.addDrinkForDay(name: "water", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-32*24*60*60))
        coreDataController.addDrinkForDay(name: "water", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-33*24*60*60))
        coreDataController.addDrinkForDay(name: "water", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-31*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 2, row: 2), "coffee")
    }

    func test_whenGetDataForCellCalledWithSection2Row3_thenReturnsDailyDrinkData7days() {
        // given
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test", timeStamp: Date())
        coreDataController.addDrinkForDay(name: "water", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 500, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-2*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-31*24*60*60))
        coreDataController.addDrinkForDay(name: "coffee", volume: 1000, imageName: "test",
                                    timeStamp: Date().addingTimeInterval(-31*24*60*60))
        coreDataController.saveContext()
        sut.didLoadData = true

        // then
        XCTAssertEqual(sut.getDataForCell(section: 2, row: 3), "1.0 drinks")
    }

}

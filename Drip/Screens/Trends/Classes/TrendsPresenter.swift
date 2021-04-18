import Foundation

final class TrendsPresenter: TrendsPresenterProtocol {
    weak private(set) var view: TrendsViewProtocol?

    let sectionHeaders = ["All Time", "Last 7 days", "Last 30 days"]
    let section1Titles = ["Average Drink", "Average Daily", "Best Day", "Worst Day", "Current Streak",
                          "Best Streak", "Favourite Drink", "Daily Drinks"]
    let section2Titles = ["Average Drink", "Average Day", "Favourite Drink", "Daily Drinks"]
    let section3Titles = ["Average Drink", "Average Day", "Favourite Drink", "Daily Drinks"]

    var didLoadData: Bool = false

    var lastWeekDate: Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        return startDate!.addingTimeInterval(-(7*24*60*60))
    }

    var lastMonthDate: Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        return startDate!.addingTimeInterval(-(30*24*60*60))
    }

    var goal: Double {
        return (view?.userDefaultsController.drinkGoal)!
    }

    init(view: TrendsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
//        view?.coreDataController.fetchDrinks()
        populateArrangedDays()
        didLoadData = true
        view?.reloadData()
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Trends")
    }

    func onViewWillDisappear() {
        arrangedDays = []
    }

    func getSectionCount() -> Int {
        return sectionHeaders.count
    }

    func getSectionHeader(for index: Int) -> String {
        return sectionHeaders[index]
    }

    func getNumberOfItemsInSection(for section: Int) -> Int {
        switch section {
        case 0:
            return section1Titles.count
        case 1:
            return section2Titles.count
        case 2:
            return section3Titles.count
        default:
            return 0
        }
    }

    func getTitleForCell(section: Int, row: Int) -> String {
        switch section {
        case 0:
            return section1Titles[row]
        case 1:
            return section2Titles[row]
        case 2:
            return section3Titles[row]
        default:
            return "Undefined"
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func getDataForCell(section: Int, row: Int) -> String {
        if didLoadData == false { return "Loading" }
        switch section {
        case 0:
            switch row {
            case 0:
                return getAverageDrink(for: .allTime)
            case 1:
                return getAverageDaily(for: .allTime)
            case 2:
                return getBestDay(for: .allTime)
            case 3:
                return getWorstDay(for: .allTime)
            case 4:
                return getCurrentStreak()
            case 5:
                return getBestStreak()
            case 6:
                return getFavouriteDrink(for: .allTime)
            case 7:
                return getDailyDrinks(for: .allTime)
            default:
                return "nil"
            }
        case 1:
            switch row {
            case 0:
                return getAverageDrink(for: .last7Days)
            case 1:
                return getAverageDaily(for: .last7Days)
            case 2:
                return getFavouriteDrink(for: .last7Days)
            case 3:
                return getDailyDrinks(for: .last7Days)
            default:
                return "nil"
            }
        case 2:
            switch row {
            case 0:
                return getAverageDrink(for: .last30Days)
            case 1:
                return getAverageDaily(for: .last30Days)
            case 2:
                return getFavouriteDrink(for: .last30Days)
            case 3:
                return getDailyDrinks(for: .last30Days)
            default:
                return "nil"
            }
        default:
            return "nil"
        }
    }

    func getAverageDrink(for timescale: TimeScale) -> String {
        guard let averageDrink = view?.coreDataController.averageDrink(from: getTimeStamp(for: timescale)),
                averageDrink != 0 else { return "-- ml"}
        return "\(Int(averageDrink))ml"
    }

    func getAverageDaily(for timescale: TimeScale) -> String {
        guard let averageDaily = view?.coreDataController.averageDaily(from: getTimeStamp(for: timescale)),
                averageDaily != 0 else { return "-- ml"}
        return "\(Int(averageDaily))ml"
    }

    func getBestDay(for timescale: TimeScale) -> String {
        guard let bestDay = view?.coreDataController.bestDay(from: getTimeStamp(for: timescale)),
                bestDay != 0 else { return "-- ml"}
        return "\(Int(bestDay))ml"
    }

    func getWorstDay(for timescale: TimeScale) -> String {
        guard let worstDay = view?.coreDataController.worstDay(from: getTimeStamp(for: timescale)),
                worstDay != 0 else { return "-- ml"}
        return "\(Int(worstDay))ml"
    }

    var arrangedDays: [Day] = []

    func populateArrangedDays() {
        guard let days = view?.coreDataController.fetchDays(from: nil) else { return }
        arrangedDays = days.sorted(by: { $0.timeStamp! > $1.timeStamp!})
    }

    func getCurrentStreak() -> String {
        var date = Date()
        var streak = 0
        for day in arrangedDays {
            if !Calendar.current.isDate(date, inSameDayAs: day.timeStamp!) {
                break
            }
            if day.didReachGoal {
                streak += 1
                date = date.dayBefore
            }
        }

        return "\(streak) day\(streak == 1 ? "" : "s")"
    }

    func getBestStreak() -> String {
        var date = Date()
        var streak = 0
        var best = 0

        for day in arrangedDays {
            if !Calendar.current.isDate(date, inSameDayAs: day.timeStamp!) {
                streak = 0
                date = day.timeStamp!
            }
            if day.didReachGoal {
                streak += 1
            } else {
                streak = 0
            }
            if streak > best { best = streak }
            date = date.dayBefore
        }
        return "\(best) day\(best == 1 ? "" : "s")"
    }

    // come back to this
    func getFavouriteDrink(for timescale: TimeScale) -> String {
        var drinkDictionary = [String: Int]()
        guard let drinkArray = view?.coreDataController.fetchDrinks(from: getTimeStamp(for: timescale)) else {
            return "--"
        }

        for drink in drinkArray {
            if let count = drinkDictionary[drink.name] {
                drinkDictionary[drink.name] = count + 1
            } else {
                drinkDictionary[drink.name] = 1
            }
        }

        var mostCommonAmount = 0
        var mostCommonName = "--"
        for key in drinkDictionary.keys.sorted().reversed() where drinkDictionary[key]! > mostCommonAmount {
                mostCommonAmount = drinkDictionary[key]!
                mostCommonName = key
        }
        return mostCommonName
    }

    func getDailyDrinks(for timescale: TimeScale) -> String {
        guard let dailyDrinks = view?.coreDataController.dailyDrinks(from: getTimeStamp(for: timescale)),
                dailyDrinks != 0 else { return "-- ml"}
        return String(format: "%.1f drinks", dailyDrinks)
    }

    func getTimeStamp(for timescale: TimeScale) -> Date? {
        switch timescale {
        case .allTime:
            return nil
        case .last7Days:
            return lastWeekDate
        case .last30Days:
            return lastMonthDate
        }
    }

    let section0ImageNames = ["drop.fill", "01.square.fill", "hand.thumbsup.fill", "hand.thumbsdown.fill",
    "star.leadinghalf.fill", "star.fill", "heart.circle.fill", "calendar"]

    let sectionXImageNames = ["drop.fill", "01.square.fill", "heart.circle.fill", "calendar"]

    func getImageNameForCell(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return section0ImageNames[indexPath.row]
        default:
            return sectionXImageNames[indexPath.row]
        }
    }

    enum TimeScale {
        case allTime, last7Days, last30Days
    }
}

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

    let userDefaults = UserDefaultsController.shared

    var goal: Double {
        return userDefaults.drinkGoal
    }

    init(view: TrendsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        view?.coreDataController.fetchDrinks()
        didLoadData = true
        view?.reloadData()
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Trends")
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
        var total: Double = 0
        var amount: Double = 0
        let drinkArray = getDrinksForRange(for: timescale)

        for drink in drinkArray {
            total += drink.volume
        }
        amount = Double(drinkArray.count)

        guard !(total == 0 || amount == 0) else { return "-- ml"}
        return "\(Int(total/amount))ml"
    }

    func getAverageDaily(for timescale: TimeScale) -> String {
        var total: Double = 0
        var days: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        let drinkArray = getDrinksForRange(for: timescale)

        for drink in drinkArray {
            total += drink.volume
            if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                days += 1
                date = drink.timeStamp
            }
        }

        guard !(total == 0 || days == 0) else { return "-- ml"}
        return "\(Int(total/days))ml"
    }

    func getBestDay(for timescale: TimeScale) -> String {
        var total: Double = 0
        var best: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        let drinkArray = getDrinksForRange(for: timescale)

        for drink in drinkArray {
            if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                date = drink.timeStamp
                total = 0
            }
            total += drink.volume
            if total > best { best = total }
        }

        guard !(best == 0) else { return "-- ml"}
        return "\(Int(best))ml"
    }

    func getWorstDay(for timescale: TimeScale) -> String {
        var total: Double = Double.greatestFiniteMagnitude
        var worst: Double = Double.greatestFiniteMagnitude
        var date = Date(timeIntervalSince1970: 0)
        let drinkArray = getDrinksForRange(for: timescale)

        for drink in drinkArray {
            if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                date = drink.timeStamp
                if total < worst { worst = total }
                total = 0
            }
            total += drink.volume
        }
        if total < worst { worst = total }

        guard !(worst > Double(Int.max)) else { return "-- ml"}
        return "\(Int(worst))ml"
    }

    func getCurrentStreak() -> String {
        var total: Double = 0
//        let goal: Double = 2000
        var date = Date()
        var streak = 0
        let drinkArray = getDrinksForRange(for: .allTime)

        for drink in drinkArray {
            if Calendar.current.isDate(date, inSameDayAs: drink.timeStamp) {
                total += drink.volume
                if total >= goal {
                    streak += 1
                    total = 0
                    date = date.addingTimeInterval(-86400)
                }
            }
            // stops scanning through if more than days difference
            if Date.daysBetween(start: date, end: drink.timeStamp) > 1 {
                break
            }
        }

        return "\(streak) day\(streak == 1 ? "" : "s")"
    }

    func getBestStreak() -> String {
        var total: Double = 0
//        let goal: Double = 2000
        var date = Date()
        var streak = 0
        var best = 0
        let drinkArray = getDrinksForRange(for: .allTime)

        // TODO: Fix this, as its buggy, possibly to do with eithe rline 253, or 259.
        for drink in drinkArray {
            if Calendar.current.isDate(date, inSameDayAs: drink.timeStamp) {
                total += drink.volume
            } else {
                date = drink.timeStamp
                streak = 0
                total = drink.volume
            }
            if total >= goal {
                streak += 1
                total = 0
                date = date.addingTimeInterval(-86400)
            }
            if streak > best { best = streak }
        }

        return "\(best) day\(best == 1 ? "" : "s")"
    }

    func getFavouriteDrink(for timescale: TimeScale) -> String {
        var drinkDictionary = [String: Int]()
        let drinkArray = getDrinksForRange(for: timescale)

        for drink in drinkArray {
            if let count = drinkDictionary[drink.name] {
                drinkDictionary[drink.name] = count + 1
            } else {
                drinkDictionary[drink.name] = 1
            }
        }

        var mostCommonAmount = 0
        var mostCommonName = "--"
        for key in drinkDictionary.keys where drinkDictionary[key]! > mostCommonAmount {
                mostCommonAmount = drinkDictionary[key]!
                mostCommonName = key
        }
        return mostCommonName
    }

    func getDailyDrinks(for timescale: TimeScale) -> String {
        var days: Double = 0
        var drinkCount: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        let drinkArray = getDrinksForRange(for: timescale)

        drinkCount = Double(drinkArray.count)
        for drink in drinkArray {
            if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                days += 1
                date = drink.timeStamp
            }
        }

        guard !(days == 0 || drinkCount == 0) else { return "-- drinks"}
        return String(format: "%.1f drinks", drinkCount/days)
    }

    func getDrinksForRange(for timeScale: TimeScale) -> [Drink] {
        guard let coreDataController = view?.coreDataController else { return [] }
        switch timeScale {
        case .allTime:
            return coreDataController.allEntries.sorted(by: { $0.timeStamp > $1.timeStamp})
        case .last7Days:
            return coreDataController.allEntries.filter({$0.timeStamp > lastWeekDate})
                .sorted(by: { $0.timeStamp > $1.timeStamp})
        case .last30Days:
            return coreDataController.allEntries.filter({$0.timeStamp > lastMonthDate})
                .sorted(by: { $0.timeStamp > $1.timeStamp})
        }
    }

    enum TimeScale {
        case allTime, last7Days, last30Days
    }
}

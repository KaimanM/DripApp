import Foundation

final class TrendsPresenter: TrendsPresenterProtocol {
    weak private(set) var view: TrendsViewProtocol?

    let sectionHeaders = ["All Time", "Last 7 days", "Last 30 days"]
    let section1Titles = ["Average Drink", "Average Daily", "Best Day", "Worst Day", "Current Streak",
                          "Best Streak", "Favourite Drink", "Daily Drinks"]
    let section2Titles = ["Average Drink", "Average Day", "Favourite Drink", "Daily Drinks"]
    let section3Titles = ["Average Drink", "Average Day", "Favourite Drink", "Daily Drinks"]

    var didLoadData: Bool = false

    init(view: TrendsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
        view?.coreDataController.fetchDrinks()
        didLoadData = true
        view?.reloadData()
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
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

    // swiftlint:disable:next cyclomatic_complexity
    func getDataForCell(section: Int, row: Int) -> String {
        if didLoadData == false { return "Loading" }
        switch section {
        case 0:
            switch row {
            case 0:
                return getAverageDrinkAllTime()
            case 1:
                return getAverageDailyAllTime()
            case 2:
                return getBestDayAllTime()
            case 3:
                return getWorstDayAllTime()
            case 4:
                return getCurrentStreak()
            case 5:
                return getBestStreak()
            case 6:
                return getFavouriteDrink()
            case 7:
                return getDailyDrinksAllTime()
            default:
                return "nil"
            }
        default:
            return "nil"
        }
    }

    func getAverageDrinkAllTime() -> String {
        var total: Double = 0
        var amount: Double = 0

        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries {
                total += drink.volume
            }
            amount = Double(coreDataController.allEntries.count)
        }
        guard !(total == 0 || amount == 0) else { return "-- ml"}
        return "\(Int(total/amount))ml"
    }

    func getAverageDailyAllTime() -> String {
        var total: Double = 0
        var days: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries.sorted(by: { $0.timeStamp > $1.timeStamp}) {
                total += drink.volume
                if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                    days += 1
                    date = drink.timeStamp
                }
            }
        }
        guard !(total == 0 || days == 0) else { return "-- ml"}
        return "\(Int(total/days))ml"
    }

    func getBestDayAllTime() -> String {
        var total: Double = 0
        var best: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries {
                if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                    date = drink.timeStamp
                    total = 0
                }
                total += drink.volume
                if total > best { best = total }
            }
        }
        guard !(best == 0) else { return "-- ml"}
        return "\(Int(best))ml"
    }

    func getWorstDayAllTime() -> String {
        var total: Double = Double.greatestFiniteMagnitude
        var worst: Double = Double.greatestFiniteMagnitude
        var date = Date(timeIntervalSince1970: 0)
        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries {
                if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                    date = drink.timeStamp
                    if total < worst { worst = total }
                    total = 0
                }
                total += drink.volume
            }
            if total < worst { worst = total }
        }
        guard !(worst > Double(Int.max)) else { return "-- ml"}
        return "\(Int(worst))ml"
    }

    func getCurrentStreak() -> String {
        var total: Double = 0
        let goal: Double = 2000
        var date = Date()
        var streak = 0

        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries.sorted(by: { $0.timeStamp > $1.timeStamp}) {
                if Calendar.current.isDate(date, inSameDayAs: drink.timeStamp) {
                    total += drink.volume
                    if total > goal {
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
        }
        return "\(streak) days"
    }

    func getBestStreak() -> String {
        var total: Double = 0
        let goal: Double = 2000
        var date = Date()
        var streak = 0
        var best = 0

        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries.sorted(by: { $0.timeStamp > $1.timeStamp}) {
                if Calendar.current.isDate(date, inSameDayAs: drink.timeStamp) {
                    total += drink.volume
                } else {
                    date = drink.timeStamp
                    streak = 0
                    total = drink.volume
                }
                if total > goal {
                    streak += 1
                    total = 0
                    date = date.addingTimeInterval(-86400)
                }
                if streak > best { best = streak }
//                print("current streak is \(streak). Best is \(best)")
            }
        }
        return "\(best) days"
    }

    func getFavouriteDrink() -> String {
        var drinkDictionary = [String: Int]()
        if let coreDataController = view?.coreDataController {
            for drink in coreDataController.allEntries {
                if let count = drinkDictionary[drink.name] {
                    drinkDictionary[drink.name] = count + 1
                } else {
                    drinkDictionary[drink.name] = 1
                }
            }
        }

        var mostCommonAmount = 0
        var mostCommonName = "No Data"
        for key in drinkDictionary.keys {
            print("\(key): \(drinkDictionary[key]!)")
            if drinkDictionary[key]! > mostCommonAmount {
                mostCommonAmount = drinkDictionary[key]!
                mostCommonName = key
            }
        }
        return mostCommonName
    }

    func getDailyDrinksAllTime() -> String {
        var days: Double = 0
        var drinkCount: Double = 0
        var date = Date(timeIntervalSince1970: 0)
        if let coreDataController = view?.coreDataController {
            drinkCount = Double(coreDataController.allEntries.count)
            for drink in coreDataController.allEntries.sorted(by: { $0.timeStamp > $1.timeStamp}) {
                if !Calendar.current.isDate(drink.timeStamp, inSameDayAs: date) {
                    days += 1
                    date = drink.timeStamp
                }
            }
        }
        guard !(days == 0 || drinkCount == 0) else { return "-- drinks"}
        return String(format: "%.1f drinks", drinkCount/days)
    }
}

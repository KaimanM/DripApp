import Foundation

protocol CoreDataControllerProtocol: class {

    func saveContext()
    func fetchEntriesForDate(date: Date) -> [Drink]
    func deleteEntry(entry: Drink)

    func addDrinkForDay(name: String, volume: Double, imageName: String, timeStamp: Date)
    func getDayForDate(date: Date) -> Day?
    func getDrinksForDate(date: Date) -> [Drink]
    func fetchDays(from date: Date?) -> [Day]
    func fetchDrinks(from date: Date?) -> [Drink]

    func averageDrink(from date: Date?) -> Double
    func averageDaily(from date: Date?) -> Double
    func dailyDrinks(from date: Date?) -> Double
    func bestDay(from date: Date?) -> Double
    func worstDay(from date: Date?) -> Double

    func fetchUnlockedAwards() -> [Award]
    func unlockAwardWithId(id: Int)
    func fetchDrinkCount() -> Int
}

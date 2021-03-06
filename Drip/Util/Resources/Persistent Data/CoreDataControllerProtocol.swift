import Foundation

protocol CoreDataControllerProtocol: AnyObject {

    func saveContext()
    func deleteEntry(entry: Drink)

    func addDrinkForDay(beverage: Beverage, volume: Double, timeStamp: Date)
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
    func deleteAward(award: Award)
}

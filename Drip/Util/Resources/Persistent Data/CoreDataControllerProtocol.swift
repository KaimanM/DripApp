import Foundation

protocol CoreDataControllerProtocol: class {
    var allEntries: [Drink] { get set }

    func saveContext()
    func fetchDrinks()
    func addDrink(name: String, volume: Double, imageName: String, timeStamp: Date)
    func fetchEntriesForDate(date: Date) -> [Drink]
    func deleteEntry(entry: Drink)

    func addDrinkForDay(name: String, volume: Double, imageName: String, timeStamp: Date)
    func getDayForDate(date: Date) -> Day?
    func getDrinksForDate(date: Date) -> [Drink]
    func getAllDays() -> [Day]
}

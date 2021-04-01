import CoreData
class CoreDataController: CoreDataControllerProtocol {

    var allEntries: [Drink] = []

    // MARK: - Core Data stack

    static var shared = CoreDataController()

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Drip")
        var isRunningTests: Bool {
            return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        }
        if isRunningTests {
            print("IS RUNNING TESTS")
            container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                print("is thread main \(Thread.isMainThread)")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchDrinks() {
        do {
            allEntries = try context.fetch(Drink.fetchRequest())
        } catch {
            fatalError("Error has occured")
        }
    }

    func addDrink(name: String, volume: Double, imageName: String, timeStamp: Date) {
        let drink = Drink(context: context)
        drink.name = name
        drink.volume = volume
        drink.imageName = imageName
        drink.timeStamp = timeStamp
        allEntries.append(drink)
    }

    func addDrinkForDay(name: String, volume: Double, imageName: String, timeStamp: Date) {
        var day: [Day] = []
        do {
            let request = Day.fetchRequest() as NSFetchRequest<Day>

            request.predicate = predicateForDayFromDate(date: timeStamp)

            try day = context.fetch(request)
        } catch {
            fatalError("Error has occured")
        }

        if day.isEmpty {
            let day = Day(context: context)
            day.goal = UserDefaultsController.shared.drinkGoal
            day.timeStamp = timeStamp
            day.didReachGoal = false
            day.total = volume
            if day.total >= day.goal { day.didReachGoal = true }

            let drink = Drink(context: context)
            drink.name = name
            drink.volume = volume
            drink.imageName = imageName
            drink.timeStamp = timeStamp

            day.addToDrinks(drink)
        } else {
            let day = day.first!

            let drink = Drink(context: context)
            drink.name = name
            drink.volume = volume
            drink.imageName = imageName
            drink.timeStamp = timeStamp

            day.total += volume
            if day.total >= day.goal { day.didReachGoal = true}

            day.addToDrinks(drink)
        }
    }

    func getDayForDate(date: Date) -> Day? {
        do {
            let request = Day.fetchRequest() as NSFetchRequest<Day>

            request.predicate = predicateForDayFromDate(date: date)

            return try context.fetch(request).first
        } catch {
            fatalError("Error has occured")
        }
    }

    func fetchDays(from date: Date? = nil) -> [Day] {
        do {
            let request = Day.fetchRequest() as NSFetchRequest<Day>

            if let date = date {
                request.predicate = NSPredicate(format: "timeStamp > %@", date as NSDate)
            }

            return try context.fetch(request)
        } catch {
            fatalError("Error has occured")
        }
    }

    func getDrinksForDate(date: Date) -> [Drink] {
        if let day = getDayForDate(date: date),
           let drinks = day.drinks?.allObjects as? [Drink] {
            return drinks
        } else {
            return []
        }
    }

    func fetchEntriesForDate(date: Date) -> [Drink] {
        do {
            let request = Drink.fetchRequest() as NSFetchRequest<Drink>

            request.predicate = predicateForDayFromDate(date: date)

            return try context.fetch(request)
        } catch {
            fatalError("Error has occured")
        }
    }

    func deleteEntry(entry: Drink) {
        guard let day = entry.day else { fatalError() }
        day.total -= entry.volume
        day.removeFromDrinks(entry)
        context.delete(entry)

        //swiftlint:disable:next empty_count
        if day.drinks!.count == 0 {
            print("deleting day")
            context.delete(day)
        }

        saveContext()
    }

    // Used to generate a predicate filter for a range of all day on a selected date
    private func predicateForDayFromDate(date: Date) -> NSPredicate {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)

        return NSPredicate(format: "timeStamp >= %@ AND timeStamp =< %@", argumentArray: [startDate!, endDate!])
    }
}

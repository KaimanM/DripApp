import CoreData
class CoreDataController: CoreDataControllerProtocol {
    // MARK: - Core Data stack

    static var shared = CoreDataController()

    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Drip")

        // The below if statement is commented out as running core data in memory causes
        // crashes when using NSExpressions. It is a long standing bug. More info here:
        // https://openradar.appspot.com/12021880
        // https://openradar.appspot.com/16644607
        // Instead we flush and use SQLite core data for the simulator.

//        if isRunningTests {
//            print("IS RUNNING TESTS")
//            container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
//        }

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
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
            day.goal = isRunningTests ? 2000 : UserDefaultsController.shared.drinkGoal
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

        if volume == 1000 {
            unlockAwardWithId(id: 11)
        } else if volume == 50 {
            unlockAwardWithId(id: 12)
        }
    }

    func fetchUnlockedAwards() -> [Award] {
        var unlockedAwards: [Award] = []
        do {
            let request = Award.fetchRequest() as NSFetchRequest<Award>
            try unlockedAwards = context.fetch(request)
        } catch {
            fatalError("Error has occured")
        }

        if unlockedAwards.isEmpty {
            print("no awards unlocked")
            return []
        } else {
            return unlockedAwards
        }
    }

    func unlockAwardWithId(id: Int) {
        var isAwardUnlocked = false
        do {
            let request = Award.fetchRequest() as NSFetchRequest<Award>
            request.predicate = NSPredicate(format: "id == %@", id as NSNumber)
            let award = try context.fetch(request).first
            if award != nil {
                isAwardUnlocked = true
                print("award is already unlocked")
            }
        } catch {
            fatalError("Error has occured")
        }

        if !isAwardUnlocked {
            let award = Award(context: context)
            award.id = Int64(id)
            award.timeStamp = Date()
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

    func fetchDrinks(from date: Date? = nil) -> [Drink] {
        do {
            let request = Drink.fetchRequest() as NSFetchRequest<Drink>

            if let date = date {
                request.predicate = NSPredicate(format: "timeStamp > %@", date as NSDate)
            }

            return try context.fetch(request)
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

    // Average Drink in trends
    func averageDrink(from date: Date? = nil) -> Double {
        var averageDrink: Double = 0
        let expressionKey = "averageDrinkVolume"
        let request = generateRequest(entityName: "Drink",
                                      from: date,
                                      function: "average:",
                                      attributeKey: "volume",
                                      expressionKey: expressionKey)
        do {
            guard let result = try context.fetch(request) as? [NSDictionary],
                  let value = result.first?.value(forKey: expressionKey) as? Double
            else { return 0 }
            averageDrink = value
        } catch {
            fatalError("Error has occured")
        }
        return averageDrink
    }

    // Average Daily in trends
    func averageDaily(from date: Date? = nil) -> Double {
        var averageDaily: Double = 0
        let expressionKey = "sumOfTotals"
        let request = generateRequest(entityName: "Day",
                                      from: date,
                                      function: "average:",
                                      attributeKey: "total",
                                      expressionKey: expressionKey)
        do {
            guard let result = try context.fetch(request) as? [NSDictionary],
                  let value = result.first?.value(forKey: "sumOfTotals") as? Double
            else { return 0 }
            averageDaily = value
        } catch {
            fatalError("Error has occured")
        }
        return averageDaily
    }

    // Daily drinks in trends
    func dailyDrinks(from date: Date? = nil) -> Double {
        var dailyDrinks: Double = 0
        let drinksRequest = Drink.fetchRequest() as NSFetchRequest<Drink>
        let daysRequest = Day.fetchRequest() as NSFetchRequest<Day>
        if let date = date {
            drinksRequest.predicate = NSPredicate(format: "timeStamp > %@", date as NSDate)
            daysRequest.predicate = NSPredicate(format: "timeStamp > %@", date as NSDate)
        }
        do {
            let drinksCount = try context.count(for: drinksRequest)
            let dayCount = try context.count(for: daysRequest)
            guard drinksCount != 0, dayCount != 0 else { return 0 }
            dailyDrinks = Double(drinksCount)/Double(dayCount)
        } catch {
            fatalError("Error has occured")
        }
        return dailyDrinks
    }

    func bestDay(from date: Date? = nil) -> Double {
        var bestDay: Double = 0
        let expressionKey = "bestDayTotal"
        let request = generateRequest(entityName: "Day",
                                      from: date,
                                      function: "max:",
                                      attributeKey: "total",
                                      expressionKey: expressionKey)

        do {
            guard let test = try context.fetch(request) as? [NSDictionary],
                  let value = test.first?.value(forKey: expressionKey) as? Double
            else { return 0 }
            bestDay = value
        } catch {
            fatalError("Error has occured")
        }
        return bestDay
    }

    func worstDay(from date: Date? = nil) -> Double {
        var worstDay: Double = 0
        let expressionKey = "worstDayTotal"
        let request = generateRequest(entityName: "Day",
                                      from: date,
                                      function: "min:",
                                      attributeKey: "total",
                                      expressionKey: expressionKey)
        do {
            guard let test = try context.fetch(request) as? [NSDictionary],
                  let value = test.first?.value(forKey: expressionKey) as? Double
            else { return 0 }
            worstDay = value
        } catch {
            fatalError("Error has occured")
        }
        return worstDay
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

        if day.goal > day.total {
            day.didReachGoal = false
        }

        //swiftlint:disable:next empty_count
        if day.drinks!.count == 0 {
            print("deleting day")
            context.delete(day)
        }

        saveContext()
    }

    func deleteAward(award: Award) {
        context.delete(award)
        saveContext()
    }

    func fetchDrinkCount() -> Int {
        let fetchRequest = Drink.fetchRequest() as NSFetchRequest<Drink>
        do {
            return try context.count(for: fetchRequest)
        } catch {
            return 0
        }
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

    func generateRequest(entityName: String,
                         from date: Date? = nil,
                         function: String,
                         attributeKey: String,
                         expressionKey: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if let date = date {
            request.predicate = NSPredicate(format: "timeStamp > %@", date as NSDate)
        }
        request.resultType = .dictionaryResultType

        let expression = NSExpressionDescription()
        expression.expression = NSExpression(forFunction: function,
                                             arguments: [NSExpression(forKeyPath: attributeKey)])
        expression.name = expressionKey
        expression.expressionResultType = .doubleAttributeType

        request.propertiesToFetch = [expression]

        return request
    }
}

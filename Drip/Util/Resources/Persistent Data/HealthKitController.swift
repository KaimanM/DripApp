import HealthKit

class HealthKitController {

    var healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            print("healthkit available")
            return HKHealthStore()
        } else {
            return nil
        }
    }()

    // Quantity type of dietary water for HealthKit
    private let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!

    // Set containing types to request HealthKit Permissions for, we use just water.
    private var typesToShare : Set<HKSampleType> {
        let waterType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        return [waterType]
    }

    // Checks authorisation status of just dietary water
    func checkAuthStatus(completion: @escaping (_ :HKAuthorizationStatus) -> Void) {
        let status = healthStore?.authorizationStatus(for: quantityType)
        if let status = status {
            completion(status)
        }
    }

    // Requests access in healthkit for dietary water
    func requestAccess(completion: @escaping (_ :Bool) -> Void) {
        healthStore?.requestAuthorization(toShare: typesToShare, read: nil) { success, _ in
            completion(success)
        }
    }

    // Adds drink entry to health kit
    func addWaterDataToHealthStore(amount: Double, date: Date) {
        let sample = HKQuantitySample(type: quantityType, quantity: getLitreQuantity(amount), start: date, end: date)

        let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)

        let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!,
                                                           start: date, end: date, objects: [sample])

        healthStore?.save(waterCorrelationForWaterAmount, withCompletion: { success, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error failed to print")
                return
            }
            switch success {
            case true:
                print("Saved to HealthKit Successfully")
            case false:
                print("Failed to save to HealthKit")
            }

        })

    }

    // Deletes HealthKit Entry with given attributes
    func deleteEntryWithAttributes(date: Date, amount: Double) {
        let startDate = date.addingTimeInterval(0)
        let endDate = date.addingTimeInterval(1)

        let datePredicate = HKSampleQuery.predicateForSamples(withStart: startDate,
                                                               end: endDate,
                                                               options: [])

        let volumePredicate = HKSampleQuery.predicateForQuantitySamples(with: .equalTo,
                                                                        quantity: getLitreQuantity(amount))

        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, volumePredicate])

        let query = HKSampleQuery(sampleType: quantityType,
                                  predicate: combinedPredicate,
                                  limit: 100,
                                  sortDescriptors: nil) { _, results, error in

            guard error == nil else {
                print(error?.localizedDescription ?? "error failed to print")
                return
            }

            if let healthKitEntry = results?.first {
                self.healthStore?.delete(healthKitEntry, withCompletion: { success, error in
                    guard error == nil else {
                        print(error?.localizedDescription ?? "error failed to print")
                        return
                    }
                    switch success {
                    case true:
                        print("Successfully removed entry from HealthKit")
                    case false:
                        print("Failed to remove entry from HealthKit")
                    }
                })
            }
        }

        healthStore?.execute(query)
    }

    // converts double ml amount to litres HKQuantity
    private func getLitreQuantity(_ mlAmount: Double) -> HKQuantity {
        return HKQuantity(unit: HKUnit(from: "l"), doubleValue: mlAmount/1000)
    }

}

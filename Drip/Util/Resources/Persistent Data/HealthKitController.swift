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

    var typesToShare : Set<HKSampleType> {
        let waterType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        return [waterType]
    }

    func checkAuthStatus(completion: @escaping (_ :HKAuthorizationStatus) -> Void) {
        let status = healthStore?.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .dietaryWater)!)
        if let status = status {
            completion(status)
        }
    }

    func requestAccess(completion: @escaping (_ :Bool) -> Void) {
        healthStore?.requestAuthorization(toShare: typesToShare, read: nil) { granted, _ in
            completion(granted)
        }
    }

    func addWaterDataToHealthStore(amount: Double, date: Date) {
        let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)

        let quantityUnit = HKUnit(from: "l")

        let quantityAmount = HKQuantity(unit: quantityUnit, doubleValue: amount/1000)

        let now = date

        let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: now, end: now)

        let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)

        let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!,
                                                           start: now, end: now, objects: [sample])

        healthStore?.save(waterCorrelationForWaterAmount, withCompletion: { success, error in
            if (error != nil) {
                print("failed to save")
            } else {
                print("saved successfully")
            }
        })

    }

    func deleteEntryWithDate(date: Date = Date(), amount: Double = 0) {
        let startDate = date.addingTimeInterval(0)
        let endDate = date.addingTimeInterval(1)

        let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)

        let datePredicate = HKSampleQuery.predicateForSamples(withStart: startDate,
                                                               end: endDate,
                                                               options: [])

        let quantityUnit = HKUnit(from: "l")

        let quantityAmount = HKQuantity(unit: quantityUnit, doubleValue: amount/1000)

        let volumePredicate = HKSampleQuery.predicateForQuantitySamples(with: .equalTo, quantity: quantityAmount)

        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, volumePredicate])

        let query = HKSampleQuery(sampleType: waterType!,
                                  predicate: combinedPredicate,
                                  limit: 100,
                                  sortDescriptors: nil) { query, results, error in

            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let first = results?.first as? HKObject {
                    self.healthStore?.delete(first, withCompletion: { success, error in
                        if success {
                            print("successfully delete item from healthkit")
                        } else {
                            print("deleting failed: \(error)")
                        }
                    })
                }
            }
        }


        healthStore?.execute(query)

    }

}

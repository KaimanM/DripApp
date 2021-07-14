@testable import Drip
import HealthKit

final class MockHealthKitController: HealthKitControllerProtocol {

    var authStatusToReturn: HKAuthorizationStatus = .notDetermined
    func checkAuthStatus(completion: @escaping (HKAuthorizationStatus) -> Void) {
        completion(authStatusToReturn)
    }

    var requestAccessResult = false

    // mock result as if user allowed/disallowed healthkit
    var requestAccessAuthStatus: HKAuthorizationStatus = .sharingAuthorized

    func requestAccess(completion: @escaping (Bool) -> Void) {
        authStatusToReturn = requestAccessAuthStatus
        completion(requestAccessResult)
    }

    var waterAddedToHealthStore: (amount: Double, date: Date)?
    func addWaterDataToHealthStore(amount: Double, date: Date) {
        waterAddedToHealthStore = (amount: amount, date: date)
    }

    var deletedEntry: (amount: Double, date: Date)?
    func deleteEntryWithAttributes(date: Date, amount: Double) {
        deletedEntry = (amount: amount, date: date)
    }
}

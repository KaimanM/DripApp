import HealthKit

protocol HealthKitControllerProtocol {
    func checkAuthStatus(completion: @escaping (_ :HKAuthorizationStatus) -> Void)
    func requestAccess(completion: @escaping (_ :Bool) -> Void)
    func addWaterDataToHealthStore(amount: Double, date: Date)
    func deleteEntryWithAttributes(date: Date, amount: Double)
}

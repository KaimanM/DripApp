import Foundation
import UserNotifications
@testable import Drip

final class MockLocalNotificationController: LocalNotificationControllerProtocol {

    var notifications = [Drip.Notification]()

    private(set) var didFetchPendingNotifications: Bool = false
    var mockedNotifications = [Drip.Notification]()
    func fetchPendingNotifications(completion: @escaping () -> Void) {
        didFetchPendingNotifications = true
        notifications = mockedNotifications
        completion()
    }

    var grantedAuth = false
    private(set) var didRequestAuth: Bool = false
    func requestAuth(completion: @escaping (Bool) -> Void) {
        didRequestAuth = true
        completion(grantedAuth)
    }

    private(set) var didCheckAuthStatus: Bool = false
    var authStatus: UNAuthorizationStatus = .denied
    // maybe move auth status here
    func checkAuthStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        didCheckAuthStatus = true
        completion(authStatus)
    }

    private(set) var didSchedule: Bool = false
    func schedule(completion: (() -> Void)?) {
        didSchedule = true
        if let completion = completion { completion() }
    }

    private(set) var didRemoveAllPendingNotifications: Bool = false
    func removeAllPendingNotifications() {
        notifications.removeAll()
        didRemoveAllPendingNotifications = true
    }

    private(set) var didRemovePendingNotificationWithId: Bool = false
    func removePendingNotificationWithId(id: Int) {
        didRemovePendingNotificationWithId = true
    }

    private(set) var didSetupDefaultNotifications: Bool = false
    func setupDefaultNotifications() {
        didSetupDefaultNotifications = true
    }

}

import Foundation

protocol NotificationDetailPresenterProtocol: AnyObject {
    var view: NotificationDetailViewProtocol? { get }
    func onViewDidLoad()

    func updateBody(body: String)
    func updateTimeStamp(date: Date)
    func isSoundEnabled() -> Bool
    func enableSound(enabled: Bool)

    func numberOfRowsInSection() -> Int
    func titleForRowAt(row: Int) -> String
}

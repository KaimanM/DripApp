import Foundation

protocol NotificationDetailPresenterProtocol: AnyObject {
    var view: NotificationDetailViewProtocol? { get }
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()

    func numberOfRowsInSection() -> Int
}

import Foundation

class NotificationDetailPresenter: NotificationDetailPresenterProtocol {
    var view: NotificationDetailViewProtocol?

    init(view: NotificationDetailViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
//        view?.updateTime
    }

    func onViewWillAppear() {
    }

    func onViewWillDisappear() {
    }

    func numberOfRowsInSection() -> Int {
        return 0
    }

}

import Foundation

class NotificationDetailPresenter: NotificationDetailPresenterProtocol {
    var view: NotificationDetailViewProtocol?

    let options = ["Message", "Sound"]

    init(view: NotificationDetailViewProtocol) {
        self.view = view
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Edit Reminder")
        setupPickerDate()
    }

    func setupPickerDate() {
        if let date = view?.notification.timeStamp.date {
            view?.updatePickerDate(date: date)
        }
    }

    func isSoundEnabled() -> Bool {
        if let enabled = view?.notification.sound {
            return enabled
        } else {
            return false
        }
    }

    // MARK: - Updating Notification -
    func updateBody(body: String) {
        view?.notification.body = body
    }

    func updateTimeStamp(date: Date) {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        view?.notification.timeStamp = DateComponents(calendar: Calendar.current,
                                                hour: hour, minute: minute)
    }

    func enableSound(enabled: Bool) {
        view?.notification.sound = enabled
        print("sound enabled \(enabled)")
    }

    // MARK: - Table View -
    func numberOfRowsInSection() -> Int {
        return options.count
    }

    func titleForRowAt(row: Int) -> String {
        return options[row]
    }

}

import Foundation

protocol HistoryPresenterProtocol: AnyObject {
    var view: HistoryViewProtocol? { get }

    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()
    func onViewWillDisappear()

    func numberOfRowsInSection() -> Int
    //swiftlint:disable:next large_tuple
    func cellForRowAt(row: Int) -> (name: String, volume: String, imageName: String, timeStampTitle: String)
    func editToggleTapped()
    func isHidingEditButton() -> Bool

    func didSelectDate(date: Date)
    func cellForDate(date: Date) -> Double
    func didTapDeleteButton(row: Int)

    func addDrinkTapped(beverage: Beverage, volume: Double)
    func deleteHealthKitEntry(volume: Double, timeStamp: Date)
}

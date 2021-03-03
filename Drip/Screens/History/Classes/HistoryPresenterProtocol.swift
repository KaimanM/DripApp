import Foundation

protocol HistoryPresenterProtocol: class {
    var view: HistoryViewProtocol? { get }

    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()

    func numberOfRowsInSection() -> Int
    func cellForRowAt(cell: DrinkTableViewCell, row: Int) -> DrinkTableViewCell

    func didSelectDate(date: Date)
    func cellForDate(cell: CustomFSCell, date: Date) -> CustomFSCell
    func didTapDeleteButton(row: Int)
}

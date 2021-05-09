import Foundation

protocol TrendsPresenterProtocol: AnyObject {
    var view: TrendsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()
    func onViewWillDisappear()

    func getSectionCount() -> Int
    func getSectionHeader(for index: Int) -> String
    func getNumberOfItemsInSection(for section: Int) -> Int
    func getTitleForCell(section: Int, row: Int) -> String
    func getDataForCell(section: Int, row: Int) -> String
    func getImageNameForCell(indexPath: IndexPath) -> String
}

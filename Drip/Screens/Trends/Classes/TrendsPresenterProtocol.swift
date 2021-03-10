protocol TrendsPresenterProtocol: class {
    var view: TrendsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()

    func getSectionCount() -> Int
    func getSectionHeader(for index: Int) -> String
    func getNumberOfItemsInSection(for section: Int) -> Int
    func getTitleForCell(section: Int, row: Int) -> String
}

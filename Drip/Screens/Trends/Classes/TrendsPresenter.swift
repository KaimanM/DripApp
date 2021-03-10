final class TrendsPresenter: TrendsPresenterProtocol {
    weak private(set) var view: TrendsViewProtocol?

    let sectionHeaders = ["Overview", "Section 22"]
    let section1Titles = ["Average Drink", "Average Daily", "Best Day", "Worst Day", "Current Streak", "Best Streak"]
    let section2Titles = ["Favourite Drink", "Hated Drink", "Daily Avg Drinks"]

    init(view: TrendsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Trends")
    }

    func getSectionCount() -> Int {
        return sectionHeaders.count
    }

    func getSectionHeader(for index: Int) -> String {
        return sectionHeaders[index]
    }

    func getNumberOfItemsInSection(for section: Int) -> Int {
        if section == 0 {
            return section1Titles.count
        } else {
            return section2Titles.count
        }
    }

    func getTitleForCell(section: Int, row: Int) -> String {
        if section == 0 {
            return section1Titles[row]
        } else {
            return section2Titles[row]
        }
    }

}

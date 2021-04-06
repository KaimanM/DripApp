final class AwardsPresenter: AwardsPresenterProtocol {
    weak private(set) var view: AwardsViewProtocol?

    let awards: [AwardsDetailDataSourceProtocol] =
        [TenDrinksAwardDataSource(), FiftyDrinksAwardDataSource(), HundredDrinksAwardDataSource(),
         FiveHundredDrinksAwardDataSource(), SevenDayBestAwardDataSource(), TwentyEightStreakAwardDataSource(),
         NinetyDayStreakAwardDataSource(), YearStreakAwardDataSource()]

    var unlockedAwards: [Award] = []

    init(view: AwardsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Awards Presenter onViewDidAppear firing correctly")
        view?.coreDataController.unlockAwardWithId(id: 0)
        unlockedAwards = view?.coreDataController.fetchUnlockedAwards() ?? []
        print(unlockedAwards)

        print(unlockedAwards.map({$0.id}).contains(2))
        view?.reloadData()
    }

    func onViewDidLoad() {
        print("Awards Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Awards")
    }

    func cellForRowAt(index: Int) -> (title: String, imageName: String) {
        if unlockedAwards.map({$0.id}).contains(Int64(awards[index].id)) {
            return (awards[index].awardName, awards[index].imageName)
        } else {
            return ("???", "locked.svg")
        }
    }

    func didSelectItemAt(index: Int) {
        let detailView = AwardsDetailView()

        if unlockedAwards.map({$0.id}).contains(Int64(awards[index].id)) {
            detailView.dataSource = awards[index]
            let timeStamp = unlockedAwards.first(where: { $0.id == index})?.timeStamp
            detailView.timeStamp = timeStamp
        } else {
            detailView.dataSource = LockedAwardDataSource()
        }

        view?.pushView(detailView)
    }

    func numberOfItemsInSection() -> Int {
        return awards.count
    }

}

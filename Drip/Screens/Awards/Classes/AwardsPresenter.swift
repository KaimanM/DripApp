final class AwardsPresenter: AwardsPresenterProtocol {
    weak private(set) var view: AwardsViewProtocol?

    let awards: [AwardsDetailDataSourceProtocol] =
        [TenDrinksAwardDataSource(), FiftyDrinksAwardDataSource(), HundredDrinksAwardDataSource(),
         FiveHundredDrinksAwardDataSource(), SevenDayBestAwardDataSource(), TwentyEightStreakAwardDataSource(),
         NinetyDayStreakAwardDataSource(), YearStreakAwardDataSource()]

    init(view: AwardsViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
        print("Awards Presenter onViewDidAppear firing correctly")
    }

    func onViewDidLoad() {
        print("Awards Presenter onViewDidLoad firing correctly")
        view?.updateTitle(title: "Awards")
    }

    func cellForRowAt(index: Int) -> (title: String, imageName: String) {
        return (awards[index].awardName, awards[index].imageName)
    }

    func didSelectItemAt(index: Int) {
        let detailView = AwardsDetailView()
        detailView.dataSource = awards[index]
        view?.pushView(detailView)
    }

    func numberOfItemsInSection() -> Int {
        return awards.count
    }

}

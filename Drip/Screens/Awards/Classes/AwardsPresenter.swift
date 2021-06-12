import Foundation

final class AwardsPresenter: AwardsPresenterProtocol {
    weak private(set) var view: AwardsViewProtocol?

    let awards: [AwardsDetailDataSourceProtocol] =
        [TenDrinksAwardDataSource(), FiftyDrinksAwardDataSource(), HundredDrinksAwardDataSource(),
         FiveHundredDrinksAwardDataSource(), SevenDayBestAwardDataSource(), TwentyEightStreakAwardDataSource(),
         NinetyDayStreakAwardDataSource(), YearStreakAwardDataSource(), ThreeUniqueDrinksAwardDataSource(),
         FiveUniqueDrinksAwardDataSource(), SevenUniqueDrinksAwardDataSource(), LitreDrinkAwardDataSource(),
         FiftymlDrinkAwardDataSource(), MissingDrinkAwardDataSource()]

    var unlockedAwards: [Award] = []

    var arrangedDays: [Day] = []

    init(view: AwardsViewProtocol) {
        self.view = view
    }

    func drinkCountAwardChecker() {
        let drinkCount = view?.coreDataController.fetchDrinkCount() ?? 0

        var awardsToUnlock: [Int] = []
        if drinkCount >= 500 {
            awardsToUnlock = [0, 1, 2, 3]
        } else if drinkCount >= 100 {
            awardsToUnlock = [0, 1, 2]
        } else if drinkCount >= 50 {
            awardsToUnlock = [0, 1]
        } else if drinkCount >= 10 {
            awardsToUnlock = [0]
        }
        awardsToUnlock.forEach({ view?.coreDataController.unlockAwardWithId(id: $0) })
    }

    func populateArrangedDays() {
        guard let days = view?.coreDataController.fetchDays(from: nil) else { return }
        arrangedDays = days.sorted(by: { $0.timeStamp! > $1.timeStamp!})
    }

    func bestStreakAwardChecker() {
        var date = Date()
        var streak = 0
        var best = 0

        for day in arrangedDays {
            if !Calendar.current.isDate(date, inSameDayAs: day.timeStamp!) {
                streak = 0
                date = day.timeStamp!
            }
            if day.didReachGoal {
                streak += 1
            } else {
                streak = 0
            }
            if streak > best { best = streak }
            date = date.dayBefore
        }

        var awardsToUnlock: [Int] = []
        if best >= 365 {
            awardsToUnlock = [4, 5, 6, 7]
        } else if best >= 90 {
            awardsToUnlock = [4, 5, 6]
        } else if best >= 28 {
            awardsToUnlock = [4, 5]
        } else if best >= 7 {
            awardsToUnlock = [4]
        }
        awardsToUnlock.forEach({ view?.coreDataController.unlockAwardWithId(id: $0) })
    }

    func uniqueDrinksAwardChecker() {
        var drinkDictionary = [String: Int]()
        guard let drinkArray = view?.coreDataController.fetchDrinks(from: nil) else { return }

        for drink in drinkArray {
            if let count = drinkDictionary[drink.name] {
                drinkDictionary[drink.name] = count + 1
            } else {
                drinkDictionary[drink.name] = 1
            }
        }

        let uniqueDrinks = drinkDictionary.keys.count

        var awardsToUnlock: [Int] = []
        if uniqueDrinks >= 7 {
            awardsToUnlock = [8, 9, 10]
        } else if uniqueDrinks >= 5 {
            awardsToUnlock = [8, 9]
        } else if uniqueDrinks >= 3 {
            awardsToUnlock = [8]
        }
        awardsToUnlock.forEach({ view?.coreDataController.unlockAwardWithId(id: $0) })
    }

    func onViewDidAppear() {
        fetchUnlockedAwards()
    }

    func fetchUnlockedAwards() {
        unlockedAwards = view?.coreDataController.fetchUnlockedAwards() ?? []
        let unlockedAwardIds = unlockedAwards.map({ $0.id })
        if !unlockedAwardIds.contains(7) {
            populateArrangedDays()
            bestStreakAwardChecker()
        }

        if !unlockedAwardIds.contains(3) {
            drinkCountAwardChecker()
        }

        if !unlockedAwardIds.contains(10) {
            uniqueDrinksAwardChecker()
        }

        unlockedAwards = view?.coreDataController.fetchUnlockedAwards() ?? []
        view?.reloadData()
    }

    func onViewDidLoad() {
        view?.updateTitle(title: "Awards")
    }

    func cellForRowAt(index: Int) -> (title: String, imageName: String) {
        if unlockedAwards.map({$0.id}).contains(Int64(awards[index].id)) {
            return (awards[index].awardName, awards[index].imageName)
        } else {
            return (awards[index].awardName, "isLocked.pdf")
        }
    }

    func didSelectItemAt(index: Int) {
        let detailView = AwardsDetailScreenBuilder().build()

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

struct NinetyDayStreakAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 6
    var imageName: String = "90dayBest.svg"
    var awardName: String = "Quarter of a year!"
    var awardBody: String =
    """
    This award was unlocked by achieving a 90 day streak.

    That's a quarter of a year you've managed this for, well done! Keep it up!
    """
}

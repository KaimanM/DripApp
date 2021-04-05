struct YearStreakAwardDataSource: AwardsDetailDataSourceProtocol {
    var imageName: String = "365dayBest.svg"
    var awardName: String = "A WHOLE YEAR!"
    var awardBody: String =
    """
    This award was unlocked by achieving a 365 day streak.

    That's a whole year you've managed! We don't even know what to say at this point \
    besides keep up the great effort. Future you is extremely thankful, we promise!
    """
}

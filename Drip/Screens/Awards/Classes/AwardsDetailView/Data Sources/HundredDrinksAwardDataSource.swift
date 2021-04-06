struct HundredDrinksAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 2
    var imageName: String = "100drinks.svg"
    var awardName: String = "One hunna!"
    var awardBody: String =
    """
    This award was unlocked by consuming 100 drinks. Happy to see you here. This still only the beggining. \
    Keep going, we're right behind you!
    """
}

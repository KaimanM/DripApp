struct HundredDrinksAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 2
    var imageName: String = "100drinks.pdf"
    var awardName: String = "One hunna!"
    var awardBody: String =
    """
    This award was unlocked by consuming 100 drinks. Happy to still see you here. This is only the beggining. \
    Keep going, we're right behind you!
    """
}

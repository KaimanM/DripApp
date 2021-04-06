struct LitreDrinkAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 11
    var imageName: String = "1000ml.svg"
    var awardName: String = "That's a gulp"
    var awardBody: String =
    """
    This award was unlocked by adding a 1 litre drink.

    Don't overdo it now okay?
    """
}

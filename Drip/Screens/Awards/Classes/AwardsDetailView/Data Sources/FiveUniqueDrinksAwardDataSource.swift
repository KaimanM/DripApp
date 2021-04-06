struct FiveUniqueDrinksAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 9
    var imageName: String = "5unique.svg"
    var awardName: String = "Collector"
    var awardBody: String =
    """
    This award was unlocked by adding 5 different types of drinks.

    Are you going for a record with how many unique drinks? We're jealous. Will you drink more?
    """
}

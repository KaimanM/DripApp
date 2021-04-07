struct MissingDrinkAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = 13
    var imageName: String = "forgotDrink.pdf"
    var awardName: String = "Forgetful?"
    var awardBody: String =
    """
    This award was unlocked by adding a missing drink in the History Tab.

    Not sure if we should call you forgetful for not adding it on the day or \
    attentive for adding it when you did. Either way, good job.
    """
}

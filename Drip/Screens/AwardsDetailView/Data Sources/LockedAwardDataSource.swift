struct LockedAwardDataSource: AwardsDetailDataSourceProtocol {
    var id = -1
    var imageName: String = "locked.pdf"
    var awardName: String = "Locked!"
    var awardBody: String = "This award is locked, carry on using the app to unlock this award!"
}

import Foundation

struct DrinkEntry {
    let drinkName: String
    let drinkVolume: Double
    let imageName: String
    let timeStamp: Date

    init(drinkName: String, drinkVolume: Double, imageName: String, timeStamp: Date) {
        self.drinkName = drinkName
        self.drinkVolume = drinkVolume
        self.imageName = imageName
        self.timeStamp = timeStamp
    }
}

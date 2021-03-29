@testable import Drip

final class MockUserDefaultsController: UserDefaultsControllerProtocol {
    var favDrink1Name: String = "MockDrink1"

    var favDrink2Name: String = "MockDrink2"

    var favDrink3Name: String = "MockDrink3"

    var favDrink4Name: String = "MockDrink4"

    var favDrink1Volume: Double = 100

    var favDrink2Volume: Double = 200

    var favDrink3Volume: Double = 300

    var favDrink4Volume: Double = 400

    var favDrink1ImageName: String = "MD1.svg"

    var favDrink2ImageName: String = "MD2.svg"

    var favDrink3ImageName: String = "MD3.svg"

    var favDrink4ImageName: String = "MD4.svg"

    var drinkGoal: Double = 2000

    var name: String = "Tony Stark"
}

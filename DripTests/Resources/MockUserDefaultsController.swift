@testable import Drip

final class MockUserDefaultsController: UserDefaultsControllerProtocol {

    var favBeverage1: Beverage = Beverage(name: "MockDrink1",
                                          imageName: "MD1.pdf",
                                          coefficient: 1.0)

    var favBeverage2: Beverage = Beverage(name: "MockDrink2",
                                         imageName: "MD2.pdf",
                                         coefficient: 1.0)

    var favBeverage3: Beverage = Beverage(name: "MockDrink3",
                                          imageName: "MD3.pdf",
                                          coefficient: 1.0)

    var favBeverage4: Beverage = Beverage(name: "MockDrink4",
                                          imageName: "MD4.pdf",
                                          coefficient: 1.0)

    var favDrink1Volume: Double = 100

    var favDrink2Volume: Double = 200

    var favDrink3Volume: Double = 300

    var favDrink4Volume: Double = 400

    var drinkGoal: Double = 2000

    var name: String = "Tony Stark"

    var completedOnboarding: Bool = false

    var useDrinkCoefficients: Bool = false

    var enabledNotifications: Bool = true

    var currentVersion: String = "1.0.0"
}

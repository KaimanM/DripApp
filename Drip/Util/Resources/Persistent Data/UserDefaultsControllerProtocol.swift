import Foundation

protocol UserDefaultsControllerProtocol: class {
    var favBeverage1: Beverage { get set }
    var favBeverage2: Beverage { get set }
    var favBeverage3: Beverage { get set }
    var favBeverage4: Beverage { get set }

    var favDrink1Volume: Double { get set }
    var favDrink2Volume: Double { get set }
    var favDrink3Volume: Double { get set }
    var favDrink4Volume: Double { get set }

    var drinkGoal: Double { get set }

    var name: String { get set }

    var completedOnboarding: Bool { get set }
    var useDrinkCoefficients: Bool { get set }
}

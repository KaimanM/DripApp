import Foundation

protocol UserDefaultsControllerProtocol: class {
    var favDrink1Name: String { get set }
    var favDrink2Name: String { get set }
    var favDrink3Name: String { get set }
    var favDrink4Name: String { get set }

    var favDrink1Volume: Double { get set }
    var favDrink2Volume: Double { get set }
    var favDrink3Volume: Double { get set }
    var favDrink4Volume: Double { get set }

    var favDrink1ImageName: String { get set }
    var favDrink2ImageName: String { get set }
    var favDrink3ImageName: String { get set }
    var favDrink4ImageName: String { get set }

    var drinkGoal: Double { get set }

    var name: String { get set }
}

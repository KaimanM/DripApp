class DrinksList {

    let drinks: [Beverage] = [
        Beverage(name: "Water", imageName: "waterbottle.svg", coefficient: 1)]

}

struct Beverage {
    let name: String
    let imageName: String
    let coefficient: Double
}

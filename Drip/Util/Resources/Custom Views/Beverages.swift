import Foundation

class Beverages {

    let drinks: [Beverage] = [
        Beverage(name: "Water", imageName: "waterbottle.svg", coefficient: 1),
        Beverage(name: "Coffee", imageName: "coffee.svg", coefficient: 0.99),
        Beverage(name: "Tea", imageName: "tea.svg", coefficient: 1),
        Beverage(name: "Milk", imageName: "milk.svg", coefficient: 0.88),
        Beverage(name: "Orange Juice", imageName: "orangejuice.svg", coefficient: 0.89),
        Beverage(name: "Juicebox", imageName: "juicebox.svg", coefficient: 0.89),
        Beverage(name: "Cola", imageName: "cola.svg", coefficient: 0.89),
        Beverage(name: "Cocktail", imageName: "cocktail.svg", coefficient: 0.6),
        Beverage(name: "Punch", imageName: "punch.svg", coefficient: 0.6),
        Beverage(name: "Milkshake", imageName: "milkshake.svg", coefficient: 0.7),
        Beverage(name: "Energy Drink", imageName: "energydrink.svg", coefficient: 0.85),
        Beverage(name: "Beer", imageName: "beer.svg", coefficient: 0.94),
        Beverage(name: "Ice Tea", imageName: "icetea.svg", coefficient: 1),
        Beverage(name: "Coconut Juice", imageName: "coconutjuice.svg", coefficient: 0.94),
        Beverage(name: "Ice Coffee", imageName: "icecoffee.svg", coefficient: 0.99),
        Beverage(name: "Smoothie", imageName: "smoothie.svg", coefficient: 0.85),
        Beverage(name: "Bubble Tea", imageName: "bubbletea.svg", coefficient: 1),
        Beverage(name: "Soda", imageName: "soda.svg", coefficient: 0.90)]
}

struct Beverage: Codable {
    let name: String
    let imageName: String
    let coefficient: Double
}

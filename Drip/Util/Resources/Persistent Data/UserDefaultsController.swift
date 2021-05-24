//
//  UserDefaultsController.swift
//  Drip
//
//  Created by Kaiman Mehmet on 24/03/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import Foundation

class UserDefaultsController: UserDefaultsControllerProtocol {

    static var shared = UserDefaultsController()

    let defaults = UserDefaults.standard
    let beverages = Beverages().drinks
    let favBeverage1Key = "favBeverage1"
    let favBeverage2Key = "favBeverage2"
    let favBeverage3Key = "favBeverage3"
    let favBeverage4Key = "favBeverage4"

    let favDrink1VolumeKey = "favDrink1Volume"
    let favDrink2VolumeKey = "favDrink2Volume"
    let favDrink3VolumeKey = "favDrink3Volume"
    let favDrink4VolumeKey = "favDrink4Volume"

    let drinkGoalKey = "drinkGoal"

    let nameKey = "name"

    let completedOnboardingKey = "completedOnboarding"

    let useDrinkCoefficientsKey = "useDrinkCoefficients"

    let enabledNotificationsKey = "enabledNotifications"

    init() {
        defaults.register(defaults: [favDrink1VolumeKey : 500,
                                     favDrink2VolumeKey : 250,
                                     favDrink3VolumeKey : 300,
                                     favDrink4VolumeKey : 350,
                                     drinkGoalKey : 2000,
                                     nameKey : "Buddy",
                                     completedOnboardingKey : false,
                                     useDrinkCoefficientsKey : true,
                                     enabledNotificationsKey : false,
                                     favBeverage1Key : encodeBeverage(beverages[0]),
                                     favBeverage2Key : encodeBeverage(beverages[1]),
                                     favBeverage3Key : encodeBeverage(beverages[2]),
                                     favBeverage4Key : encodeBeverage(beverages[3])
        ])
    }

    lazy var favBeverage1: Beverage = {
        let decoder = JSONDecoder()
        let savedBeverage = defaults.object(forKey: favBeverage1Key) as? Data
        return decodeBeverage(savedBeverage)
    }() {
        didSet {
            defaults.set(encodeBeverage(favBeverage1), forKey: favBeverage1Key)
        }
    }

    lazy var favBeverage2: Beverage = {
        let decoder = JSONDecoder()
        let savedBeverage = defaults.object(forKey: favBeverage2Key) as? Data
        return decodeBeverage(savedBeverage)
    }() {
        didSet {
            defaults.set(encodeBeverage(favBeverage2), forKey: favBeverage2Key)
        }
    }

    lazy var favBeverage3: Beverage = {
        let decoder = JSONDecoder()
        let savedBeverage = defaults.object(forKey: favBeverage3Key) as? Data
        return decodeBeverage(savedBeverage)
    }() {
        didSet {
            defaults.set(encodeBeverage(favBeverage3), forKey: favBeverage3Key)
        }
    }

    lazy var favBeverage4: Beverage = {
        let decoder = JSONDecoder()
        let savedBeverage = defaults.object(forKey: favBeverage4Key) as? Data
        return decodeBeverage(savedBeverage)
    }() {
        didSet {
            defaults.set(encodeBeverage(favBeverage4), forKey: favBeverage4Key)
        }
    }

    lazy var favDrink1Volume: Double = {
            return defaults.double(forKey: favDrink1VolumeKey)
        }() {
            didSet {
                defaults.set(favDrink1Volume, forKey: favDrink1VolumeKey)
            }
        }
    lazy var favDrink2Volume: Double = {
            return defaults.double(forKey: favDrink2VolumeKey)
        }() {
            didSet {
                defaults.set(favDrink2Volume, forKey: favDrink2VolumeKey)
            }
        }
    lazy var favDrink3Volume: Double = {
            return defaults.double(forKey: favDrink3VolumeKey)
        }() {
            didSet {
                defaults.set(favDrink3Volume, forKey: favDrink3VolumeKey)
            }
        }
    lazy var favDrink4Volume: Double = {
            return defaults.double(forKey: favDrink4VolumeKey)
        }() {
            didSet {
                defaults.set(favDrink4Volume, forKey: favDrink4VolumeKey)
            }
        }

    lazy var drinkGoal: Double = {
            return defaults.double(forKey: drinkGoalKey)
        }() {
            didSet {
                defaults.set(drinkGoal, forKey: drinkGoalKey)
            }
        }

    lazy var name: String = {
            return defaults.string(forKey: nameKey)!
        }() {
            didSet {
                defaults.set(name, forKey: nameKey)
            }
        }

    lazy var completedOnboarding: Bool = {
        return defaults.bool(forKey: completedOnboardingKey)
    }() {
        didSet {
            defaults.set(completedOnboarding, forKey: completedOnboardingKey)
        }
    }

    lazy var useDrinkCoefficients: Bool = {
        return defaults.bool(forKey: useDrinkCoefficientsKey)
    }() {
        didSet {
            defaults.set(useDrinkCoefficients, forKey: useDrinkCoefficientsKey)
        }
    }

    lazy var enabledNotifications: Bool = {
        return defaults.bool(forKey: enabledNotificationsKey)
    }() {
        didSet {
            defaults.set(enabledNotifications, forKey: enabledNotificationsKey)
        }
    }

    func encodeBeverage(_ beverage: Beverage) -> Data {
        let encoder = JSONEncoder() // should this be safer?
        let encodedBeverage = try? encoder.encode(beverage)
        return encodedBeverage!
    }

    func decodeBeverage(_ data: Data?) -> Beverage {
        let decoder = JSONDecoder()
        if let data = data,
           let loadedBeverage = try? decoder.decode(Beverage.self, from: data) {
            return loadedBeverage
        } else {
            return beverages[0]
        }
    }
}

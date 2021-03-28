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
    let favDrink1NameKey = "favDrink1Name"
    let favDrink2NameKey = "favDrink2Name"
    let favDrink3NameKey = "favDrink3Name"
    let favDrink4NameKey = "favDrink4Name"

    let favDrink1VolumeKey = "favDrink1Volume"
    let favDrink2VolumeKey = "favDrink2Volume"
    let favDrink3VolumeKey = "favDrink3Volume"
    let favDrink4VolumeKey = "favDrink4Volume"

    let favDrink1ImageNameKey = "favDrink1ImageName"
    let favDrink2ImageNameKey = "favDrink2ImageName"
    let favDrink3ImageNameKey = "favDrink3ImageName"
    let favDrink4ImageNameKey = "favDrink4ImageName"

    let drinkGoalKey = "drinkGoal"

    let nameKey = "name"

    init() {
        defaults.register(defaults: [favDrink1NameKey : "Water",
                                     favDrink2NameKey : "Coffee",
                                     favDrink3NameKey : "Tea",
                                     favDrink4NameKey : "Milk",
                                     favDrink1VolumeKey : 500,
                                     favDrink2VolumeKey : 250,
                                     favDrink3VolumeKey : 300,
                                     favDrink4VolumeKey : 350,
                                     favDrink1ImageNameKey : "waterbottle.svg",
                                     favDrink2ImageNameKey : "coffee.svg",
                                     favDrink3ImageNameKey : "tea.svg",
                                     favDrink4ImageNameKey : "milk.svg",
                                     drinkGoalKey : 2000,
                                     nameKey : "Buddy"
        ])
    }

    lazy var favDrink1Name: String = {
            return defaults.string(forKey: favDrink1NameKey)!
        }() {
            didSet {
                defaults.set(favDrink1Name, forKey: favDrink1NameKey)
            }
        }
    lazy var favDrink2Name: String = {
            return defaults.string(forKey: favDrink2NameKey)!
        }() {
            didSet {
                defaults.set(favDrink2Name, forKey: favDrink2NameKey)
            }
        }
    lazy var favDrink3Name: String = {
            return defaults.string(forKey: favDrink3NameKey)!
        }() {
            didSet {
                defaults.set(favDrink3Name, forKey: favDrink3NameKey)
            }
        }
    lazy var favDrink4Name: String = {
            return defaults.string(forKey: favDrink4NameKey)!
        }() {
            didSet {
                defaults.set(favDrink4Name, forKey: favDrink4NameKey)
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

    lazy var favDrink1ImageName: String = {
            return defaults.string(forKey: favDrink1ImageNameKey)!
        }() {
            didSet {
                defaults.set(favDrink1ImageName, forKey: favDrink1ImageNameKey)
            }
        }
    lazy var favDrink2ImageName: String = {
            return defaults.string(forKey: favDrink2ImageNameKey)!
        }() {
            didSet {
                defaults.set(favDrink2ImageName, forKey: favDrink2ImageNameKey)
            }
        }
    lazy var favDrink3ImageName: String = {
            return defaults.string(forKey: favDrink3ImageNameKey)!
        }() {
            didSet {
                defaults.set(favDrink3ImageName, forKey: favDrink3ImageNameKey)
            }
        }
    lazy var favDrink4ImageName: String = {
            return defaults.string(forKey: favDrink4ImageNameKey)!
        }() {
            didSet {
                defaults.set(favDrink4ImageName, forKey: favDrink4ImageNameKey)
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
}

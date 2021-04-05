//
//  Day+CoreDataProperties.swift
//  Drip
//
//  Created by Kaiman Mehmet on 31/03/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//
//

import Foundation
import CoreData

extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var timeStamp: Date?
    @NSManaged public var didReachGoal: Bool
    @NSManaged public var goal: Double
    @NSManaged public var total: Double
    @NSManaged public var drinks: NSSet?

}

// MARK: Generated accessors for drinks
extension Day {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

extension Day : Identifiable {

}

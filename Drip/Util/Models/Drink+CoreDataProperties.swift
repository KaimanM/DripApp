//
//  Drink+CoreDataProperties.swift
//  Drip
//
//  Created by Kaiman Mehmet on 31/03/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//
//

import Foundation
import CoreData

extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var imageName: String
    @NSManaged public var name: String
    @NSManaged public var timeStamp: Date
    @NSManaged public var volume: Double
    @NSManaged public var day: Day?

}

extension Drink : Identifiable {

}

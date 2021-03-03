//
//  Drink+CoreDataProperties.swift
//  
//
//  Created by Kaiman Mehmet on 03/03/2021.
//
//

import Foundation
import CoreData

extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var name: String
    @NSManaged public var volume: Double
    @NSManaged public var imageName: String
    @NSManaged public var timeStamp: Date

}

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
    @NSManaged public var coefficientEnabled: Bool
    @NSManaged public var coefficientVolume: Double
    @NSManaged public var day: Day?

}

extension Drink : Identifiable {

}

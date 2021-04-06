import Foundation
import CoreData

extension Award {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Award> {
        return NSFetchRequest<Award>(entityName: "Award")
    }

    @NSManaged public var id: Int64
    @NSManaged public var timeStamp: Date?

}

extension Award : Identifiable {

}

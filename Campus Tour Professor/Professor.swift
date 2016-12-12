import UIKit
import Parse
import Bolts
//Professor class to parse
class Professor:PFObject,PFSubclassing {
    @NSManaged var firstName:String
    @NSManaged var middleName:String
    @NSManaged var lastName:String
    @NSManaged var email:String
    @NSManaged var phoneNumber:String
    @NSManaged var officeHours:String
    @NSManaged var specalization:String
    @NSManaged var office:String
    @NSManaged var building:String
    @NSManaged var image:PFFile
    
    static func parseClassName() -> String {
        return "Professor"
    }
    
}
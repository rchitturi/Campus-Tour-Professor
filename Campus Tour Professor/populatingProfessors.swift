//
//  populatingProfessors.swift
//  Campus Tour Professor
//
//  Created by Chitturi,Rakesh on 11/30/16.
//  Copyright © 2016 Chitturi,Rakesh. All rights reserved.
//

import Foundation
import Parse

class PopulatingProfessors{
    //Array of professors
    static var professors:[Professor]! = []
    //Professors to populate from back4pp
    class func populateProfessors(){
        let query = PFQuery(className: "Professor")
        query.findObjectsInBackgroundWithBlock({(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.professors = objects as! [Professor]

            }
        })
    }
}
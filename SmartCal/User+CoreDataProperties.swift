//
//  User+CoreDataProperties.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "UserInfo")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}

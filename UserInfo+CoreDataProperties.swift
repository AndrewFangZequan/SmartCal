//
//  UserInfo+CoreDataProperties.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension UserInfo : Identifiable {

}

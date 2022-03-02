//
//  UserItem+CoreDataProperties.swift
//  
//
//  Created by 胡淨淳 on 2021/7/19.
//
//

import Foundation
import CoreData


extension UserItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserItem> {
        return NSFetchRequest<UserItem>(entityName: "UserItem")
    }

    @NSManaged public var account: String?
    @NSManaged public var password: String?
    @NSManaged public var userStatus: Int32

}

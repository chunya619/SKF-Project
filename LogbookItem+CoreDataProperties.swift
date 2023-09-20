//
//  LogbookItem+CoreDataProperties.swift
//  
//
//  Created by 胡淨淳 on 2022/3/11.
//
//

import Foundation
import CoreData


extension LogbookItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogbookItem> {
        return NSFetchRequest<LogbookItem>(entityName: "LogbookItem")
    }

    @NSManaged public var comments: String?
    @NSManaged public var departureTime: String?
    @NSManaged public var enginOil: String?
    @NSManaged public var fuel: String?
    @NSManaged public var journeyID: Int32
    @NSManaged public var mBegin: String?
    @NSManaged public var mEnd: String?
    @NSManaged public var passengers: String?
    @NSManaged public var returnTime: String?
    @NSManaged public var route: String?
    @NSManaged public var updater: String?
    @NSManaged public var owner: JourneyItem?

}

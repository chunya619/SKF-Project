//
//  JourneyItem+CoreDataProperties.swift
//  
//
//  Created by 胡淨淳 on 2022/3/17.
//
//

import Foundation
import CoreData


extension JourneyItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JourneyItem> {
        return NSFetchRequest<JourneyItem>(entityName: "JourneyItem")
    }

    @NSManaged public var car: Int32
    @NSManaged public var destination: String?
    @NSManaged public var id: Int32
    @NSManaged public var journeyStatus: Int32
    @NSManaged public var returnTime: String?
    @NSManaged public var startTime: String?
    @NSManaged public var status: String?
    @NSManaged public var address: String?
    @NSManaged public var logbook: LogbookItem?

}

//
//  PlanEntity+CoreDataProperties.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 09/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
//

import Foundation
import CoreData


extension PlanEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanEntity> {
        return NSFetchRequest<PlanEntity>(entityName: "PlanEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var weeks: NSSet?

}

// MARK: Generated accessors for weeks
extension PlanEntity {

    @objc(addWeeksObject:)
    @NSManaged public func addToWeeks(_ value: WeekEntity)

    @objc(removeWeeksObject:)
    @NSManaged public func removeFromWeeks(_ value: WeekEntity)

    @objc(addWeeks:)
    @NSManaged public func addToWeeks(_ values: NSSet)

    @objc(removeWeeks:)
    @NSManaged public func removeFromWeeks(_ values: NSSet)

}

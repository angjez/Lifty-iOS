//
//  WeekEntity+CoreDataProperties.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 09/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
//

import Foundation
import CoreData


extension WeekEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekEntity> {
        return NSFetchRequest<WeekEntity>(entityName: "WeekEntity")
    }

    @NSManaged public var ofPlan: PlanEntity?
    @NSManaged public var days: NSSet?

}

// MARK: Generated accessors for days
extension WeekEntity {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: DayEntity)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: DayEntity)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

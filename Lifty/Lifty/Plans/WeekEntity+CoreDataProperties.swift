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
import UIKit

import Foundation
import CoreData
import UIKit
extension WeekEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekEntity> {
        return NSFetchRequest<WeekEntity>(entityName: "WeekEntity")
    }
    
    @NSManaged public var ofPlan: PlanEntity?
    @NSManaged public var index: Int32
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

func loadWeeks (planEntity: PlanEntity, loadedPlan: Plan) {
    if (planEntity.weeks!.count > 0) {
        for _ in 1...planEntity.weeks!.count {
            loadedPlan.weeks.append(Week())
        }
        for weekEntity in planEntity.weeks! {
            let loadedWeek = Week()
            loadDays(weekEntity: weekEntity as! WeekEntity, week: loadedWeek, loadedPlan: loadedPlan)
            loadedPlan.weeks[Int((weekEntity as! WeekEntity).index)] = loadedWeek
        }
    }
}

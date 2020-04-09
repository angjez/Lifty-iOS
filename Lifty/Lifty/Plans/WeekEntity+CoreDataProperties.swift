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

func saveWeekForPlan (week: Week, weekEntity: WeekEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    var dayEntities = [DayEntity(context: managedObjectContext)]
    for day in week.days {
        let newDayEntity = DayEntity(context: managedObjectContext)
        saveWorkoutsForDay(day: day, dayEntity: newDayEntity)
        dayEntities.append(newDayEntity)
    }
    
    weekEntity.days = NSSet.init (array: dayEntities)
    
    do {
        try managedObjectContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func loadWeeks (plan: Plan) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let weekFetchRequest = NSFetchRequest<WeekEntity>(entityName: "WeekEntity")
    do {
        let weekEntities = try managedObjectContext.fetch(weekFetchRequest)
        for weekEntity in weekEntities {
            if weekEntity.ofPlan!.name == plan.name {
                let loadedWeek = Week()
                loadDays(week: loadedWeek, plan: plan)
                if (!loadedWeek.days.isEmpty) {
                    plan.weeks.append(loadedWeek)
                }
            }
        }
    } catch let error as NSError {
        print("Could not load. \(error), \(error.userInfo)")
    }
}

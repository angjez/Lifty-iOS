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
import UIKit

import Foundation
import CoreData
import UIKit
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

func savePlan (plan: Plan) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let planEntity = PlanEntity(context: managedObjectContext)
    planEntity.name = plan.name
    
    var weekEntities = [WeekEntity(context: managedObjectContext)]
    for week in plan.weeks {
        let newWeekEntity = WeekEntity(context: managedObjectContext)
        saveWeekForPlan(week: week, weekEntity: newWeekEntity)
        weekEntities.append(newWeekEntity)
    }
    
    planEntity.weeks = NSSet.init (array: weekEntities)
    
    do {
        try managedObjectContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func loadPlans () {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<PlanEntity>(entityName: "PlanEntity")
    do {
        let planEntities = try managedObjectContext.fetch(fetchRequest)
        for planEntity in planEntities {
            if (planEntity.value(forKey: "name") as? String != nil) {
                let loadedPlan = Plan(name: planEntity.value(forKey: "name") as! String)
                loadWeeks(plan: loadedPlan)
                globalPlansVC?.plans.append(loadedPlan)
            }
        }
    } catch let error as NSError {
        print("Could not load. \(error), \(error.userInfo)")
    }
}

func deletePlan (plan: Plan) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlanEntity")
    do {
        guard let planEntities = try? managedObjectContext.fetch(fetchRequest) else { return }
        
        for planEntity in planEntities {
            if (planEntity.value(forKey: "name") as! String) == plan.name {
                managedObjectContext.delete(planEntity)
            }
        }
        try managedObjectContext.save()
    } catch let error as NSError {
        print("\(error)")
    }
}

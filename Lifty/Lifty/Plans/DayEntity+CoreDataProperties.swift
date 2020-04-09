//
//  DayEntity+CoreDataProperties.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 09/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension DayEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayEntity> {
        return NSFetchRequest<DayEntity>(entityName: "DayEntity")
    }
    
    @NSManaged public var ofWeek: WeekEntity?
    @NSManaged public var workouts: NSSet?
    
}

// MARK: Generated accessors for workouts
extension DayEntity {
    
    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: WorkoutEntity)
    
    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: WorkoutEntity)
    
    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)
    
    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)
    
}

func saveWorkoutsForDay (day: Day, dayEntity: DayEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    var workoutEntitiesForTheDay = [WorkoutEntity(context: managedObjectContext)]
    let fetchRequest = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    do {
        let workoutEntities = try managedObjectContext.fetch(fetchRequest)
        for workout in day.workouts {
            for workoutEntity in workoutEntities {
                if ((workoutEntity.value(forKey: "name") as? String) == workout.name) {
                    workoutEntitiesForTheDay.append(workoutEntity)
                }
            }
        }
    } catch let error as NSError {
        print("Could not load. \(error), \(error.userInfo)")
    }
    dayEntity.workouts = NSSet.init (array: workoutEntitiesForTheDay)
    
    do {
        try managedObjectContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

func loadDays(week: Week, plan: Plan) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let dayFetchRequest = NSFetchRequest<DayEntity>(entityName: "DayEntity")
    do {
        let dayEntities = try managedObjectContext.fetch(dayFetchRequest)
        for dayEntity in dayEntities {
            if dayEntity.ofWeek!.ofPlan!.name == plan.name {
                let loadedDay = Day()
                for workout in dayEntity.workouts! {
                    loadWorkoutsForDay (day: loadedDay, workoutName: ((((workout as AnyObject).name) as String?)!))
                }
                if (!loadedDay.workouts.isEmpty) {
                    week.days.append(loadedDay)
                }
            }
        }
    } catch let error as NSError {
        print("Could not load. \(error), \(error.userInfo)")
    }
}

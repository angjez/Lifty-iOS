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
    @NSManaged public var index: Int32
    
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


func loadDays(weekEntity: WeekEntity, week: Week, loadedPlan: Plan) {
    if (weekEntity.days!.count > 0) {
        for _ in 1...weekEntity.days!.count {
            week.days.append(Day())
        }
        for dayEntity in weekEntity.days! {
            let loadedDay = Day()
            for workout in (dayEntity as! DayEntity).workouts! {
                if((workout as! WorkoutEntity).name != nil) {
                    loadWorkoutsForDay (day: loadedDay, workoutName: (workout as! WorkoutEntity).name!)
                }
            }
            week.days[Int((dayEntity as! DayEntity).index)] = loadedDay
        }
    }
}

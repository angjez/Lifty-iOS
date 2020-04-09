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

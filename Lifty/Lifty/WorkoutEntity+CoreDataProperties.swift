//
//  WorkoutEntity+CoreDataProperties.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 24/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var time: String?
    @NSManaged public var restTime: String?
    @NSManaged public var rounds: Int32
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension WorkoutEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

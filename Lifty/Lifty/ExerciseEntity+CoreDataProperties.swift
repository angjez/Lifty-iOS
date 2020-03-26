//
//  ExerciseEntity+CoreDataProperties.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 24/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var index: Int32
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var reps: Int32
    @NSManaged public var time: String?
    @NSManaged public var type: String?
    @NSManaged public var ofWorkout: WorkoutEntity?

}

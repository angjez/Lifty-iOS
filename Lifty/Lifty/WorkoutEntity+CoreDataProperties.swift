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
import UIKit


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

func saveWorkout (workout: Workout) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let workoutEntity = WorkoutEntity(context: managedObjectContext)
    workoutEntity.name = workout.name
    workoutEntity.rounds = Int32(workout.rounds)
    workoutEntity.type = workout.type
    workoutEntity.time = workout.time
    workoutEntity.restTime = workout.restTime
    
    var exerciseEntities = [ExerciseEntity(context: managedObjectContext)]
    for (index, exercise) in workout.exercises.enumerated() {
        let newExerciseEntity = ExerciseEntity(context: managedObjectContext)
        newExerciseEntity.name = exercise.exerciseName
        newExerciseEntity.index = Int32(exercise.exerciseIndex)
        newExerciseEntity.notes = exercise.notes
        newExerciseEntity.reps = Int32(exercise.reps)
        newExerciseEntity.type = exercise.exerciseType
        newExerciseEntity.time = exercise.exerciseTime
        exerciseEntities.append(newExerciseEntity)
    }
    
    workoutEntity.exercises = NSSet.init (array: exerciseEntities)
    
    do {
        try managedObjectContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
    
}


func deleteWorkout (workout: Workout) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorkoutEntity")
    do {
        guard let workoutEntities = try? managedObjectContext.fetch(fetchRequest) else { return }
        
        for workoutEntity in workoutEntities {
            if (workoutEntity.value(forKey: "name") as? String) == workout.name {
                managedObjectContext.delete(workoutEntity)
            }
        }
    }
}

func loadWorkouts () {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    do {
        let workoutEntities = try managedObjectContext.fetch(fetchRequest)
        for workoutEntity in workoutEntities {
            if (workoutEntity.value(forKey: "name") as? String != nil) {
//            print(workoutEntity.value(forKey: "name") as? String)
            let loadedWorkout = Workout()
            loadedWorkout.name = workoutEntity.value(forKey: "name") as! String
            loadedWorkout.type = workoutEntity.value(forKey: "type") as! String
            loadedWorkout.time = workoutEntity.value(forKey: "time") as! String
            loadedWorkout.restTime = workoutEntity.value(forKey: "restTime") as! String
            loadedWorkout.rounds = workoutEntity.value(forKey: "rounds") as! Int
//            let loadedExercises = Array(workoutEntity.exercises!)
//            for exerciseEntity in loadedExercises {
//                let loadedExercise = Exercise(exerciseIndex: (exerciseEntity as AnyObject).value(forKey: "index") as! Int)
//            }
//            print(loadedWorkout.name)
//                print(workoutEntity.exercises!.count)
                let exerciseFetchRequest = NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
                let exerciseEntities = try managedObjectContext.fetch(exerciseFetchRequest)
                for exerciseEntity in exerciseEntities {
                    if exerciseEntity.ofWorkout!.name == loadedWorkout.name {
                        if (exerciseEntity.name != nil) {
                            let loadedExercise = Exercise(exerciseIndex: Int(exerciseEntity.index))
                            loadedExercise.exerciseName = exerciseEntity.name!
                            loadedExercise.exerciseType = exerciseEntity.type!
                            loadedExercise.reps = Int(exerciseEntity.reps)
                            loadedExercise.exerciseTime = exerciseEntity.time!
                            if (exerciseEntity.notes != nil) {
                                loadedExercise.notes = exerciseEntity.notes!
                            }
                            loadedWorkout.addExercise(exercise: loadedExercise)
                        }
                    }
                }
            globalSavedWorkoutsVC?.workouts.append(loadedWorkout)
            }
        }
    } catch let error as NSError {
        print("Could not load. \(error), \(error.userInfo)")
    }
}

func deleteAll () {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorkoutEntity")
    do {
        guard let workoutEntities = try? managedObjectContext.fetch(fetchRequest) else { return }
        
        for workoutEntity in workoutEntities {
            managedObjectContext.delete(workoutEntity)
        }
    }
}

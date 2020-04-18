//
//  WorkoutDocument.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class WorkoutDocument : Document {
    
    var collectionRef: CollectionReference? = nil
    
    override init(uid: String) {
        super.init(uid: uid)
        self.collectionRef = db.collection("workouts")
    }
    
    //    MARK: Methods for setting values for workouts.
    
    func setWorkoutDocument (workout: Workout) {
        let batch = db.batch()
        let workoutsRef = self.collectionRef!.document(self.uid).collection("workouts").document(workout.name)
        batch.setData([
            "name": workout.name,
            "type": workout.type,
            "time": workout.time,
            "restTime": workout.restTime,
            "rounds": workout.rounds
        ], forDocument: workoutsRef)
        for exercise in workout.exercises {
            setExerciseDocument(exercise: exercise, rootDoc: self.collectionRef!.document(self.uid).collection("workouts").document(workout.name), batch: batch)
        }
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func setExerciseDocument(exercise: Exercise, rootDoc: DocumentReference, batch: WriteBatch) {
        let exerciseRef = rootDoc.collection("exercises").document(exercise.exerciseName)
        batch.setData([
            "name": exercise.exerciseName,
            "type": exercise.exerciseType,
            "time": exercise.exerciseTime,
            "index": exercise.exerciseIndex,
        ], forDocument: exerciseRef)
    }
    
    //    MARK: Methods for getting the values for workouts.
    
    func getWorkoutDocument () {
        
    }
    
    //    MARK: Methods for deleting workouts.
    
    func deleteWorkoutDocument (workout: Workout) {
        let batch = db.batch()
        let workoutsRef = self.collectionRef!.document(self.uid).collection("workouts").document(workout.name)
        for exercise in workout.exercises {
            setExerciseDocument(exercise: exercise, rootDoc: self.collectionRef!.document(self.uid).collection("workouts").document(workout.name), batch: batch)
        }
        batch.deleteDocument(workoutsRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func deleteExerciseDocument(exercise: Exercise, rootDoc: DocumentReference, batch: WriteBatch) {
        let exerciseRef = rootDoc.collection("exercises").document(exercise.exerciseName)
        batch.deleteDocument(exerciseRef)
    }
    
}

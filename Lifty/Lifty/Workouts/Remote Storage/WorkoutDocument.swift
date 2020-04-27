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
    
    func setWorkoutDocument (workout: Workout, completion: @escaping () -> Void) {
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
            setExerciseDocument(exercise: exercise, rootDoc: self.collectionRef!.document(self.uid).collection("workouts").document(workout.name), batch: batch, completion: {
            })
        }
        batch.commit() { err in
            if let err = err {
                completion()
                print("Error writing batch \(err)")
            } else {
                completion()
                print("Batch write succeeded.")
            }
        }
    }
    
    func setExerciseDocument(exercise: Exercise, rootDoc: DocumentReference, batch: WriteBatch, completion: @escaping () -> Void) {
        let exerciseRef = rootDoc.collection("exercises").document(exercise.exerciseName)
        batch.setData([
            "name": exercise.exerciseName,
            "type": exercise.exerciseType,
            "time": exercise.exerciseTime,
            "index": exercise.exerciseIndex,
            "reps": exercise.reps,
            "notes": exercise.notes
        ], forDocument: exerciseRef)
        completion()
    }
    
    //    MARK: Methods for getting the values for workouts.
    
    func getWorkoutDocument (completion: @escaping ([Workout]) -> Void)  {
        var loadedWorkouts = [Workout]()
        self.collectionRef!.document(self.uid).collection("workouts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(loadedWorkouts)
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let workout = Workout(name: "")
                    self.manageLoadedWorkoutData(workout: workout, data: document.data())
                    self.getWorkoutExercises(workoutName: workout.name, completion: { exercises in
                        workout.exercises = exercises
                    })
                    loadedWorkouts.append(workout)
                }
                completion(loadedWorkouts)
            }
        }
    }
    
    //    Assigning data to a workout.
    func manageLoadedWorkoutData (workout: Workout, data: [String:Any]) {
        for data in data {
            switch data.key {
            case "name":
                workout.name = data.value as! String
            case "type":
                workout.type = data.value as! String
            case "time":
                workout.time = data.value as! String
            case "restTime":
                workout.restTime = data.value as! String
            case "rounds":
                workout.rounds = data.value as! Int
            default:
                print("Undefined key.")
            }
        }
    }
    
    func getWorkoutExercises (workoutName: String, completion: @escaping ([Exercise]) -> Void) {
        var exercises = [Exercise]()
        self.collectionRef!.document(self.uid).collection("workouts").document(workoutName).collection("exercises").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(exercises)
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let exercise = Exercise(exerciseIndex: 0)
                    self.manageLoadedExerciseData(exercise: exercise, data: document.data())
                    exercises.append(exercise)
                }
                exercises.sort {
                    $0.exerciseIndex < $1.exerciseIndex
                }
                completion(exercises)
            }
        }
    }
    
    //    Assigning data to an exercise.
    func manageLoadedExerciseData (exercise: Exercise, data: [String:Any]) {
        for data in data {
            switch data.key {
            case "index":
                exercise.exerciseIndex = data.value as! Int
            case "name":
                exercise.exerciseName = data.value as! String
            case "type":
                exercise.exerciseType = data.value as! String
            case "notes":
                exercise.notes = data.value as! String
            case "time":
                exercise.exerciseTime = data.value as! String
            case "reps":
                exercise.reps = data.value as! Int
            default:
                print("Undefined key.")
            }
        }
    }
    
    //    MARK: Methods for deleting workouts.
    
    func deleteWorkoutDocument (workout: Workout) {
        let batch = db.batch()
        let workoutsRef = self.collectionRef!.document(self.uid).collection("workouts").document(workout.name)
        for exercise in workout.exercises {
            deleteExerciseDocument(exercise: exercise, rootDoc: self.collectionRef!.document(self.uid).collection("workouts").document(workout.name), batch: batch, completion: {
            })
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
    
    func deleteExerciseDocument(exercise: Exercise, rootDoc: DocumentReference, batch: WriteBatch, completion: @escaping () -> Void) {
        let exerciseRef = rootDoc.collection("exercises").document(exercise.exerciseName)
        batch.deleteDocument(exerciseRef)
    }
    
}

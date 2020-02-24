//
//  DataClasses.swift
//  WODder
//
//  Created by Angelika Jeziorska on 22/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class Workout {
    var name: String?
    var type: String?
    var time: Int?
    var restTime: Int?
    var rounds: Int?
    var exercises = [Exercise]()
    
//    init(name: String, type: String, time: Int, restTime: Int, rounds: Int) {
//        self.name = name
//        self.type = type
//        self.time = time
//        self.restTime = restTime
//        self.rounds = rounds
//    }
    
    func addExercise (exercise: Exercise) {
        self.exercises.append(exercise)
    }
}


class Exercise {
    var exerciseName: String
    var exerciseType: String?
    var reps: Int?
    var exerciseTime: String?
    var notes: String?
    var exerciseIndex: Int
    
    init(exerciseName: String, exerciseIndex: Int) {
        self.exerciseName = exerciseName
        self.exerciseIndex = exerciseIndex
    }
    
//    init(exerciseName: String, exerciseType: String, reps: Int, exerciseTime: String, notes: String, exerciseIndex: Int) {
//        self.exerciseName = exerciseName
//        self.exerciseType = exerciseType
//        self.reps = reps
//        self.exerciseTime = exerciseTime
//        self.notes = notes
//        self.exerciseIndex = exerciseIndex
//    }
    
    func assign(exerciseToAssign: Exercise) {
        self.exerciseName = exerciseToAssign.exerciseName
        self.exerciseType = exerciseToAssign.exerciseType
        self.reps = exerciseToAssign.reps
        self.exerciseTime = exerciseToAssign.exerciseTime
        self.notes = exerciseToAssign.notes
        self.exerciseIndex = exerciseToAssign.exerciseIndex
    }
}

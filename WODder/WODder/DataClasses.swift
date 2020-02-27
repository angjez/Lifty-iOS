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
    
    func addExercise (exercise: Exercise) {
        self.exercises.append(exercise)
    }
}


class Exercise {
    var exerciseIndex: Int
    var exerciseName: String
    var exerciseType: String?
    var reps: Int?
    var exerciseTime: String?
    var notes: String?
    
    init(exerciseName: String, exerciseIndex: Int) {
        self.exerciseName = exerciseName
        self.exerciseIndex = exerciseIndex
    }
    
    func assign(exerciseToAssign: Exercise) {
        self.exerciseName = exerciseToAssign.exerciseName
        self.exerciseType = exerciseToAssign.exerciseType
        self.reps = exerciseToAssign.reps
        self.exerciseTime = exerciseToAssign.exerciseTime
        self.notes = exerciseToAssign.notes
        self.exerciseIndex = exerciseToAssign.exerciseIndex
    }
}

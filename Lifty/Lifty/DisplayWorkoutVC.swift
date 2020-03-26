//
//  DisplayWorkoutVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 19/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

class DisplayWorkoutVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var specyficsLabel: UILabel!
    
    @IBOutlet weak var exercisesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = chosenWorkout.name
        typeLabel.text = (chosenWorkout.type ?? "Workout")
        checkType()
        loadExercises()
        
    }

    func checkType () {
        var rounds: String?
        if (chosenWorkout.type != "AMRAP" && chosenWorkout.rounds>1) {
            rounds = " rounds of:"
        }
        else {
            rounds = " round of:"
        }
        switch chosenWorkout.type {
        case "AMRAP":
            specyficsLabel.text! +=  "Time cap: " +  (chosenWorkout.time) + "'. "
        case "EMOM":
            specyficsLabel.text! += "Every " + (chosenWorkout.time
        ) + ". "
            specyficsLabel.text! +=  String(chosenWorkout.rounds) + rounds!
        case "FOR TIME":
            specyficsLabel.text! += "Time cap: " +  (chosenWorkout.time) + "'. "
            specyficsLabel.text! += String(chosenWorkout.rounds) + rounds!
        case "TABATA":
            specyficsLabel.text! += (chosenWorkout.time) + " on " + (chosenWorkout.restTime) + " off. "
            specyficsLabel.text! +=  String(chosenWorkout.rounds) + rounds!
        default:
            specyficsLabel.text! = ""
        }
    }
    
    func loadExercises () {
        for exercise in chosenWorkout.exercises {
            if exercise.exerciseType == "Reps" {
                exercisesTextView.text += String(exercise.reps) + "    " + exercise.exerciseName + "\n"
            }
            else if exercise.exerciseType == "Time" {
                exercisesTextView.text += exercise.exerciseTime + "    " + exercise.exerciseName + "\n"
            }
        }
    }

}

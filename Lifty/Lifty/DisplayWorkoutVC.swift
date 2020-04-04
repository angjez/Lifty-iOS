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
    
    @IBOutlet weak var timeRepsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = " " + " " + chosenWorkout.name
        typeLabel.text = " " + " " + (chosenWorkout.type ?? "Workout")
        checkType()
        loadExercises()

        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.borderWidth = 3.0
        
        
        guard
            let flareGradientImage = CAGradientLayer.primaryGradient(on: self.view)
            else {
                print("Error creating gradient color!")
                return
            }
        
        self.view.backgroundColor = UIColor(patternImage: flareGradientImage)
        
        exercisesTextView.adjustUITextViewHeight()
        timeRepsTextView.adjustUITextViewHeight()
    }

    func checkType () {
        var rounds: String?
        specyficsLabel.text! += " " + " "
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
        
        specyficsLabel.layer.borderColor = UIColor.white.cgColor
        specyficsLabel.layer.borderWidth = 3.0

        
    }
    
    func loadExercises () {
        for exercise in chosenWorkout.exercises {
            timeRepsTextView.text += "\n"
            exercisesTextView.text += "\n"
            if exercise.exerciseType == "Reps" {
                timeRepsTextView.text += String(exercise.reps) + "\n"
                exercisesTextView.text += exercise.exerciseName + "\n"
            }
            else if exercise.exerciseType == "Time" {
                timeRepsTextView.text += exercise.exerciseTime + "\n"
                exercisesTextView.text += exercise.exerciseName + "\n"
            }
            if exercise.notes != " " && exercise.notes != "" {
                let linesBefore = exercisesTextView.numberOfLines()
                exercisesTextView.text += exercise.notes + "\n"
                let linesAfter = exercisesTextView.numberOfLines()
                for _ in 1...(linesAfter-linesBefore) {
                    timeRepsTextView.text += "\n"
                }
            }
        }
        exercisesTextView.adjustUITextViewHeight()
        timeRepsTextView.adjustUITextViewHeight()
        exercisesTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        timeRepsTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        exercisesTextView.layer.borderColor = UIColor.white.cgColor
        exercisesTextView.layer.borderWidth = 3.0
        
        timeRepsTextView.layer.borderColor = UIColor.white.cgColor
        timeRepsTextView.layer.borderWidth = 3.0
    }
}

//MARK: - UITextView
extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func adjustUITextViewHeight()
    {
        var frame = self.frame
        frame.size.height = self.contentSize.height
        self.frame = frame
        
    }

}

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

        titleLabel.text = " " +  globalSavedWorkoutsVC!.chosenWorkout.name + " "
        typeLabel.text = " " + globalSavedWorkoutsVC!.chosenWorkout.type
        checkType()
        loadExercises()

        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
        titleLabel.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = UIColor.systemIndigo
        typeLabel.textColor = UIColor.lightGray
        
        self.view.backgroundColor = UIColor.white
        
    }

    func checkType () {
        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
        var rounds: String?
        specyficsLabel.text! += " " + " "
        if (globalSavedWorkoutsVC!.chosenWorkout.type != "AMRAP" && globalSavedWorkoutsVC!.chosenWorkout.rounds>1) {
            rounds = " rounds of:"
        }
        else {
            rounds = " round of:"
        }
        switch globalSavedWorkoutsVC!.chosenWorkout.type {
        case "AMRAP":
            specyficsLabel.text! +=  "Time cap: " +  (globalSavedWorkoutsVC!.chosenWorkout.time) + "'. "
        case "EMOM":
            specyficsLabel.text! += "Every " + (globalSavedWorkoutsVC!.chosenWorkout.time
        ) + ". "
            specyficsLabel.text! +=  String(globalSavedWorkoutsVC!.chosenWorkout.rounds) + rounds!
        case "FOR TIME":
            specyficsLabel.text! += "Time cap: " +  (globalSavedWorkoutsVC!.chosenWorkout.time) + "'. "
            specyficsLabel.text! += String(globalSavedWorkoutsVC!.chosenWorkout.rounds) + rounds!
        case "TABATA":
            specyficsLabel.text! += (globalSavedWorkoutsVC!.chosenWorkout.time) + " on " + (globalSavedWorkoutsVC!.chosenWorkout.restTime) + " off. "
            specyficsLabel.text! +=  String(globalSavedWorkoutsVC!.chosenWorkout.rounds) + rounds!
        default:
            specyficsLabel.text! = ""
        }
        
        specyficsLabel.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
        specyficsLabel.layer.borderWidth = 3.0
        specyficsLabel.textColor = UIColor.systemIndigo

        
    }
    
    func loadExercises () {
        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
        for exercise in globalSavedWorkoutsVC!.chosenWorkout.exercises {
            print(exercise.exerciseName)
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
        exercisesTextView.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
        exercisesTextView.layer.borderWidth = 3.0

        timeRepsTextView.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
        timeRepsTextView.layer.borderWidth = 3.0
        
        exercisesTextView.textColor = UIColor.systemIndigo
        timeRepsTextView.textColor = UIColor.systemIndigo
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

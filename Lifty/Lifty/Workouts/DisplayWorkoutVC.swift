//
//  DisplayWorkoutVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 19/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

class DisplayWorkoutVC: UIViewController, passWorkout, passWorkoutFromPlans {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var specyficsLabel: UILabel!
    
    @IBOutlet weak var exercisesTextView: UITextView!
    @IBOutlet weak var timeRepsTextView: UITextView!
    
    var chosenWorkout = Workout(name: "")
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = " " +  self.chosenWorkout.name + " "
        typeLabel.text = " " + self.chosenWorkout.type
        checkType()
        loadExercises()
        
        
        titleLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = theme
        typeLabel.textColor = UIColor.lightGray
        
        self.view.backgroundColor = UIColor.white
        
    }
    
    func finishPassing(chosenWorkout: Workout) {
        self.chosenWorkout = chosenWorkout
        self.theme = .systemIndigo
        self.gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        self.viewDidLoad()
    }
    
    func finishPassingFromPlans(chosenWorkout: Workout) {
        self.chosenWorkout = chosenWorkout
        self.theme = .systemPink
        gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        self.viewDidLoad()
    }
    
    func checkType () {
        var rounds: String?
        specyficsLabel.text! += " " + " "
        if (self.chosenWorkout.type != "AMRAP" && self.chosenWorkout.rounds>1) {
            rounds = " rounds of:"
        }
        else {
            rounds = " round of:"
        }
        switch self.chosenWorkout.type {
        case "AMRAP":
            specyficsLabel.text! +=  "Time cap: " +  (self.chosenWorkout.time) + "'. "
        case "EMOM":
            specyficsLabel.text! += "Every " + (self.chosenWorkout.time
                ) + ". "
            specyficsLabel.text! +=  String(self.chosenWorkout.rounds) + rounds!
        case "FOR TIME":
            specyficsLabel.text! += "Time cap: " +  (self.chosenWorkout.time) + "'. "
            specyficsLabel.text! += String(self.chosenWorkout.rounds) + rounds!
        case "TABATA":
            specyficsLabel.text! += (self.chosenWorkout.time) + " on " + (self.chosenWorkout.restTime) + " off. "
            specyficsLabel.text! +=  String(self.chosenWorkout.rounds) + rounds!
        default:
            specyficsLabel.text! = ""
        }
        
        specyficsLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        specyficsLabel.layer.borderWidth = 3.0
        specyficsLabel.textColor = theme
        
        
    }
    
    func loadExercises () {
        for exercise in self.chosenWorkout.exercises {
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
        exercisesTextView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        exercisesTextView.layer.borderWidth = 3.0
        
        timeRepsTextView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        timeRepsTextView.layer.borderWidth = 3.0
        
        exercisesTextView.textColor = theme
        timeRepsTextView.textColor = theme
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

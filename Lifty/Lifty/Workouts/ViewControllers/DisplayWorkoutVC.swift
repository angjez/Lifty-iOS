//
//  DisplayWorkoutVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 19/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

class DisplayWorkoutVC: UIViewController, passWorkout, passWorkoutFromPlans, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var specyficsLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    @IBOutlet weak var exercisesTextView: UITextView!
    @IBOutlet weak var timeRepsTextView: UITextView!
    
    var chosenWorkout = Workout(name: "")
    
    var workoutDelegate: passWorkout?
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLabels()
        self.setButton()
        
        checkType()
        
        self.view.backgroundColor = UIColor.white
        
    }
    
    func setLabels () {
        titleLabel.text = " " +  self.chosenWorkout.name + " "
        typeLabel.text = " " + self.chosenWorkout.type
        titleLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = theme
        typeLabel.textColor = UIColor.lightGray
    }
    
    func setButton () {
        startWorkoutButton.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        startWorkoutButton.layer.borderWidth = 3.0
        startWorkoutButton.setTitle("Start workout", for: .normal)
        startWorkoutButton.setTitleColor(theme, for: .normal)
    }
    
    func setTextViewAppearance(textView: UITextView) {
        textView.delegate  = self
        textView.showsHorizontalScrollIndicator = false
        textView.adjustUITextViewHeight()
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        textView.layer.borderWidth = 3.0
        textView.textColor = theme
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == exercisesTextView{
            timeRepsTextView.contentOffset = exercisesTextView.contentOffset
        }else{
            exercisesTextView.contentOffset = timeRepsTextView.contentOffset
        }
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenWorkout: Workout) {
        self.chosenWorkout = chosenWorkout
        self.theme = .systemIndigo
        self.gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        loadExercises()
        self.viewDidLoad()
    }
    
    func finishPassingFromPlans(chosenWorkout: Workout) {
        self.chosenWorkout = chosenWorkout
        self.theme = .systemPink
        gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        loadExercises()
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TimerVC{
            self.workoutDelegate = destinationVC
            self.workoutDelegate?.finishPassing(chosenWorkout: self.chosenWorkout)
        }
    }
    
    //    MARK: Assigning data to labels and text views.
    
    func checkType () {
        var rounds: String?
        specyficsLabel.text! = ""
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
        print(chosenWorkout.exercises.count)
        for exercise in chosenWorkout.exercises {
            print(exercise.exerciseName)
            timeRepsTextView.text += "\n"
            exercisesTextView.text += "\n"
            if exercise.exerciseType == "Reps" {
                timeRepsTextView.text += String(exercise.reps) + "\n"
                print()
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
        
        self.setTextViewAppearance(textView: exercisesTextView)
        self.setTextViewAppearance(textView: timeRepsTextView)
    }
}

//MARK: - UITextView extension for height adjustment.
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
        if self.contentSize.height < 500 {
            frame.size.height = self.contentSize.height
        } else {
            frame.size.height = 500
        }
        self.frame = frame
        
    }
    
}

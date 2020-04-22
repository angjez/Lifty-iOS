//
//  TimerVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 21/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

class TimerVC: UIViewController, passWorkout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeTimeLabel: UILabel!
    
    @IBOutlet weak var currentExerciseLabel: UILabel!
    @IBOutlet weak var exercisesTextView: UITextView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var minorTimerLabler: UILabel!
    
    @IBOutlet weak var roundCounterLabel: UILabel!
    
    @IBOutlet weak var lockScreenButton: UIButton!
    @IBOutlet weak var pauseWorkoutButton: UIButton!
    
    var currentWorkout: Workout?
    var isPaused = false
    var isLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitleTypeLabel()
        setCircularButtons(button: lockScreenButton)
        setCircularButtons(button: pauseWorkoutButton)
        
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector (pauseTap))
        let pausePressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pausePress))
        pausePressGesture.minimumPressDuration = 5
        pauseWorkoutButton.addGestureRecognizer(pauseTapGesture)
        pauseWorkoutButton.addGestureRecognizer(pausePressGesture)
        
        let lockTapGesture = UITapGestureRecognizer(target: self, action: #selector (lockTap))
        let lockPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(lockPress))
        lockPressGesture.minimumPressDuration = 5
        lockScreenButton.addGestureRecognizer(lockTapGesture)
        lockScreenButton.addGestureRecognizer(lockPressGesture)
    }
    
    func finishPassing(chosenWorkout: Workout) {
        self.currentWorkout = chosenWorkout
    }
    
    func setTitleTypeLabel() {
        titleLabel.text = " "
        titleLabel.text! += currentWorkout!.name
        let gradient = CAGradientLayer.greenGradient(on: self.view)!
        titleLabel.layer.borderColor = UIColor(patternImage: gradient).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = UIColor(patternImage: gradient)
        typeTimeLabel.text = currentWorkout?.type
        guard let workoutTime = self.currentWorkout?.time
            else {
                print("Error assigning time.")
                return
        }
        guard let restTime = self.currentWorkout?.restTime
            else {
                print("Error assigning rest time.")
                return
        }
        switch self.currentWorkout?.type {
        case "AMRAP":
            typeTimeLabel.text! +=  " Time cap: " +  (workoutTime) + "'. "
        case "FOR TIME":
            typeTimeLabel.text! += " Time cap: " +  (workoutTime) + "'. "
        case "TABATA":
            typeTimeLabel.text! += " " + (workoutTime) + " on "
            typeTimeLabel.text! += (restTime) + " off. "
        default:
            typeTimeLabel.text! = ""
        }
    }
    
    func setCircularButtons (button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
   @IBAction func pauseTap(_ gestureRecognizer : UITapGestureRecognizer ) {
        if !self.isPaused && !self.isLocked {
            self.isPaused = true
            pauseWorkoutButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            pauseWorkoutButton.backgroundColor = .red
            lockScreenButton.setImage(UIImage(systemName: "play"), for: .normal)
        }
    }
    
    @IBAction func pausePress(_ sender: UILongPressGestureRecognizer) {
        if self.isPaused {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func lockTap(_ gestureRecognizer : UITapGestureRecognizer ) {
        if self.isPaused && !self.isLocked {
            self.isPaused = false
            pauseWorkoutButton.setImage(UIImage(systemName: "pause"), for: .normal)
            pauseWorkoutButton.backgroundColor = .lightGray
            lockScreenButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        } else if !self.isLocked {
            self.isLocked = true
            lockScreenButton.setImage(UIImage(systemName: "lock"), for: .normal)
            pauseWorkoutButton.isEnabled = false
        }
    }
    
    @IBAction func lockPress(_ sender: UILongPressGestureRecognizer) {
        if !self.isPaused && self.isLocked {
            self.isLocked = false
            lockScreenButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
            pauseWorkoutButton.isEnabled = true
        }
    }
    
}

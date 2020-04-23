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
    
    var countdownTimer: Timer?
    var countdownTimerDuration = 10.0
    
    var timer: Timer?
    var secondaryTimer: Timer?
    
    var workoutTimeCap: Double?
    var workoutDuration = 0.0
    
    var exerciseTime: Double?
    var exerciseDuration = 0.0
    
    var completedExercises = 0
    
    var isMain: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCircularButtons(button: lockScreenButton)
        self.setCircularButtons(button: pauseWorkoutButton)
        //self.addPauseGestures()
        self.addLockGestures()
        
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector (pauseTap))
        let pausePressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pausePress))
        pausePressGesture.minimumPressDuration = 5
        pauseWorkoutButton.addGestureRecognizer(pauseTapGesture)
        pauseWorkoutButton.addGestureRecognizer(pausePressGesture)
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownTimerFires), userInfo: nil, repeats: true)
        self.setTitleTypeLabel()
        
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
            self.roundCounterLabel.text = "Round: 1/\(self.currentWorkout!.rounds)"
            typeTimeLabel.text! += " " + (workoutTime) + " on "
            typeTimeLabel.text! += (restTime) + " off. "
        case "EMOM":
            self.roundCounterLabel.text = "Round: 1/\(self.currentWorkout!.rounds)"
            if (self.currentWorkout?.exercises.count)! >= 1 {
                self.currentExerciseLabel.text = self.currentWorkout?.exercises[0].exerciseName
            }
            if (self.currentWorkout?.exercises.count)! >= 2 {
                exercisesTextView.text = self.currentWorkout!.exercises[1].exerciseName
            }
        default:
            typeTimeLabel.text! = ""
        }
        if self.currentWorkout?.type != "EMOM" {
            for exercise in self.currentWorkout!.exercises {
                exercisesTextView.text += exercise.exerciseName
            }
        }
    }
    
    func setCircularButtons(button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    // MARK: Configuring the timer based on workout type.
    /** Progress bar is the same for every workout and shows progress for the whole workout. */
    
    /**
     + primary timer shows overall workout time
     
     - round couner is empty (might add a round counter)
     - secondary timer is empty
     - next up label is empty
     - current exercise label is empty
     */
    func forTimeSetup() {
        self.isMain = true
        if let workoutTimeString = self.currentWorkout?.time {
            workoutTimeCap = Double(workoutTimeString)! * 60.0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
        } else {
            print("Error assigning time.")
            return
        }
    }
    
    /**
     + primary timer shows the duration of the current exercise (typically 1 minute)
     + secondary timer shows overall workout time
     + current exercise label active
     + round couner is active
     + next up label is active and shows the next workout from `workout.exercises`
     */
    func EMOMsetup() {
        self.isMain = false
        if let workoutTimeString = self.currentWorkout?.time {
            let colon = workoutTimeString.firstIndex(of: ":")!
            let minutes = Double(workoutTimeString.prefix(upTo: colon))
            let seconds = minutes! * 60.0 + Double(workoutTimeString.suffix(2))!
            workoutTimeCap = seconds * Double(self.currentWorkout!.rounds)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
            
            exerciseTime = seconds
            
            secondaryTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(exerciseTimerFires), userInfo: nil, repeats: true)
            
        } else {
            print("Error assigning time.")
            return
        }
    }
    
    func nextEMOMexercise() {
        if self.currentWorkout!.exercises.count % completedExercises == 0 {
            self.roundCounterLabel.text = "Round: \(completedExercises/self.currentWorkout!.exercises.count+1)/\(self.currentWorkout!.rounds)"
        }
        
        self.currentExerciseLabel.text = self.currentWorkout!.exercises[completedExercises % self.currentWorkout!.exercises.count].exerciseName
        
        if completedExercises < self.currentWorkout!.exercises.count * self.currentWorkout!.rounds {
            exercisesTextView.text = self.currentWorkout!.exercises[(completedExercises+1) % self.currentWorkout!.exercises.count].exerciseName
        }
    }
    
    /**
     + primary timer shows overall workout time
     
     - secondary timer is empty (might add a round counter and use it for round duration)
     - current exercise label is empty
     - round couner is empty (might add a round counter)
     - next up label is empty
     */
    func AMRAPsetup() {
        
    }
    
    /**
     + primary timer shows rest/work time
     + secondary timer shows overall workout time
     + current exercise label shows if the time displayed indicates work or rest time
     + round couner is active
     
     - next up label is empty
     */
    func TABATAsetup() {
        
    }
    
    // MARK: Timer methods.
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    @objc func workoutTimerFires(_ sender: Any)
    {
        var label = UILabel()
        if let isMain = self.isMain {
            if isMain {
                label = timerLabel
            } else {
                label = minorTimerLabler
            }
        }
        workoutDuration += 1
        
        label.text = timeString(time: workoutDuration)
        
        if workoutDuration >= workoutTimeCap! {
            timer?.invalidate()
            timer = nil
            label.textColor = .darkGray
            label.text = "Finished!"
            secondaryTimer = nil
            secondaryTimer?.invalidate()
        }
    }
    
    @objc func exerciseTimerFires(_ sender: Any)
    {
        exerciseDuration += 1
        
        timerLabel.text = timeString(time: exerciseDuration)
        
        if exerciseDuration >= exerciseTime! {
            completedExercises += 1
            
            if self.currentWorkout?.type == "EMOM" {
                nextEMOMexercise()
                if completedExercises != self.currentWorkout!.exercises.count * self.currentWorkout!.rounds {
                    exerciseDuration = 0.0
                } else {
                    secondaryTimer = nil
                    secondaryTimer?.invalidate()
                }
            } else if self.currentWorkout?.type == "TABATA" {
                
            }
            
        }
    }
    
    // A countdown timer to let the user prepare for a workout.
    
    @objc func countdownTimerFires()
    {
        countdownTimerDuration -= 1
        timerLabel.text = "\(Int(countdownTimerDuration))"
        timerLabel.textColor = .darkGray
        
        if countdownTimerDuration <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            timerLabel.textColor = .systemGreen
            timerLabel.text = "Go!"
            switch self.currentWorkout?.type {
            case "AMRAP":
                self.AMRAPsetup()
            case "FOR TIME":
                self.forTimeSetup()
            case "TABATA":
                self.TABATAsetup()
            case "EMOM":
                self.EMOMsetup()
            default:
                print("Unknown type.")
            }
        }
    }
    
    // MARK: Gesture regognisers for buttons.
    // MARK: TODO: Add an indicator for the user to know when to long press to finish a workout/unlock the screen.
    
    func addPauseGestures() {
        let pauseTapGesture = UITapGestureRecognizer(target: self, action: #selector (pauseTap))
        let pausePressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pausePress))
        pausePressGesture.minimumPressDuration = 5
        self.pauseWorkoutButton.addGestureRecognizer(pauseTapGesture)
        self.pauseWorkoutButton.addGestureRecognizer(pausePressGesture)
    }
    
    func addLockGestures() {
        let lockTapGesture = UITapGestureRecognizer(target: self, action: #selector (lockTap))
        let lockPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(lockPress))
        lockPressGesture.minimumPressDuration = 5
        self.lockScreenButton.addGestureRecognizer(lockTapGesture)
        self.lockScreenButton.addGestureRecognizer(lockPressGesture)
    }
    
    @IBAction func pauseTap(_ gestureRecognizer : UITapGestureRecognizer ) {
        if !self.isPaused && !self.isLocked {
            self.isPaused = true
            // pause timers
            self.timer?.invalidate()
            self.timer = nil
            self.secondaryTimer?.invalidate()
            self.secondaryTimer = nil
            self.countdownTimer?.invalidate()
            self.countdownTimer = nil
            
            self.pauseWorkoutButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            self.pauseWorkoutButton.backgroundColor = .red
            self.lockScreenButton.setImage(UIImage(systemName: "play"), for: .normal)
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
            self.pauseWorkoutButton.setImage(UIImage(systemName: "pause"), for: .normal)
            self.pauseWorkoutButton.backgroundColor = .lightGray
            self.lockScreenButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
            
            // resume timers
            if countdownTimer == nil && secondaryTimer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
            } else if countdownTimer == nil && secondaryTimer != nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
                self.secondaryTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(exerciseTimerFires), userInfo: nil, repeats: true)
            }else {
                self.countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownTimerFires), userInfo: nil, repeats: true)
            }
        } else if !self.isLocked {
            self.isLocked = true
            self.lockScreenButton.setImage(UIImage(systemName: "lock"), for: .normal)
            self.pauseWorkoutButton.isEnabled = false
        }
    }
    
    @IBAction func lockPress(_ sender: UILongPressGestureRecognizer) {
        if !self.isPaused && self.isLocked {
            self.isLocked = false
            self.lockScreenButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
            self.pauseWorkoutButton.isEnabled = true
        }
    }
    
}

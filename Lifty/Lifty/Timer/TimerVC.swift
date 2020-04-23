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
    
    var completed = 0
    
    var isMain: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCircularButtons(button: lockScreenButton)
        self.setCircularButtons(button: pauseWorkoutButton)
        self.addPauseGestures()
        self.addLockGestures()
        
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
        case "AMRAP", "FOR TIME":
            typeTimeLabel.text! +=  " Time cap: " +  (workoutTime) + "'. "
        case "TABATA":
            self.currentExerciseLabel.text = "Work"
            self.roundCounterLabel!.text = "Round: 1/\(self.currentWorkout!.rounds)"
            typeTimeLabel.text! += " " + (workoutTime) + " on "
            typeTimeLabel.text! += (restTime) + " off. "
        case "EMOM":
            self.roundCounterLabel!.text = "Round: 1/\(self.currentWorkout!.rounds)"
            if (self.currentWorkout?.exercises.count)! >= 1 {
                let currentExercise = self.currentWorkout?.exercises[0]
                if currentExercise?.exerciseType == "Reps" {
                    currentExerciseLabel.text = String(currentExercise!.reps) + " "
                } else {
                    currentExerciseLabel.text = currentExercise!.exerciseTime + " "
                }
                currentExerciseLabel.text! += currentExercise!.exerciseName
            }
            if (self.currentWorkout?.exercises.count)! >= 2 {
                let nextExercise = self.currentWorkout!.exercises[1]
                if nextExercise.exerciseType == "Reps" {
                    exercisesTextView.text = String(nextExercise.reps) + " "
                } else {
                    exercisesTextView.text = nextExercise.exerciseTime + " "
                }
                exercisesTextView.text += nextExercise.exerciseName
            }
        default:
            typeTimeLabel.text! = ""
        }
        if self.currentWorkout?.type != "EMOM" {
            for exercise in self.currentWorkout!.exercises {
                if exercise.exerciseType == "Reps" {
                    exercisesTextView.text += String(exercise.reps) + " " + exercise.exerciseName + "\n"
                } else {
                    exercisesTextView.text += exercise.exerciseTime + " " + exercise.exerciseName + "\n"
                }
            }
        }
    }
    
    func setCircularButtons(button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    // MARK: Configuring the timer based on workout type.
    /** Progress bar is the same for every workout and shows progress for the whole workout. */
    
    func getSeconds(workoutTimeString: String) -> Double {
        let colon = workoutTimeString.firstIndex(of: ":")!
        let minutes = Double(workoutTimeString.prefix(upTo: colon))
        return minutes! * 60.0 + Double(workoutTimeString.suffix(2))!
    }
    
    /**
     + primary timer shows overall workout time
     + next up label displays all exercises in the workout
     
     - round couner is empty (might add a round counter)
     - secondary timer is empty
     - current exercise label is empty
     */
    func forTimeAMRAPSetup() {
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
            let seconds = getSeconds(workoutTimeString: workoutTimeString)
            workoutTimeCap = seconds * Double(self.currentWorkout!.rounds) * Double(self.currentWorkout!.exercises.count)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
            
            exerciseTime = seconds
            
            secondaryTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(exerciseTimerFires), userInfo: nil, repeats: true)
            
        } else {
            print("Error assigning time.")
            return
        }
    }
    
    func nextEMOMexercise() {
        if self.currentWorkout!.exercises.count % completed == 0 {
            self.roundCounterLabel!.text = "Round: \(completed/self.currentWorkout!.exercises.count+1)/\(self.currentWorkout!.rounds)"
        }
        
        let currentExercise = self.currentWorkout!.exercises[completed % self.currentWorkout!.exercises.count]
        if currentExercise.exerciseType == "Reps" {
            currentExerciseLabel.text = String(currentExercise.reps) + " "
        } else {
            currentExerciseLabel.text = currentExercise.exerciseTime + " "
        }
        self.currentExerciseLabel.text! += currentExercise.exerciseName
        
        if completed < self.currentWorkout!.exercises.count * self.currentWorkout!.rounds {
            let nextExercise = self.currentWorkout!.exercises[(completed+1) % self.currentWorkout!.exercises.count]
            if nextExercise.exerciseType == "Reps" {
                exercisesTextView.text = String(nextExercise.reps) + " "
            } else {
                exercisesTextView.text = nextExercise.exerciseTime + " "
            }
            exercisesTextView.text += nextExercise.exerciseName
        } else {
            exercisesTextView.text = nil
        }
    }
    
    /**
     + primary timer shows rest/work time
     + secondary timer shows overall workout time
     + current exercise label shows if the time displayed indicates work or rest time
     + round couner is active
     + next up label displays all exercises in the workout
     */
    func TABATAsetup() {
        self.isMain = false
        if let workTimeString = self.currentWorkout?.time {
            if let restTimeString = self.currentWorkout?.restTime {
                let workSeconds = getSeconds(workoutTimeString: workTimeString)
                let restSeconds = getSeconds(workoutTimeString: restTimeString)
                workoutTimeCap = (workSeconds + restSeconds) * Double(self.currentWorkout!.rounds)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(workoutTimerFires), userInfo: nil, repeats: true)
                
                exerciseTime = workSeconds
                
                secondaryTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(exerciseTimerFires), userInfo: nil, repeats: true)
            }
        } else {
            print("Error assigning time.")
            return
        }
    }
    
    func nextTABATAperiod() {
        if completed % 2 == 0 {
            self.roundCounterLabel!.text = "Round: \(completed/2+1)/\(self.currentWorkout!.rounds)"
        }
        if let workTimeString = self.currentWorkout?.time {
            if let restTimeString = self.currentWorkout?.restTime {
                let workSeconds = getSeconds(workoutTimeString: workTimeString)
                let restSeconds = getSeconds(workoutTimeString: restTimeString)
                
                if exerciseTime == workSeconds {
                    currentExerciseLabel.text = "Rest"
                    exerciseTime = restSeconds
                } else {
                    currentExerciseLabel.text = "Work"
                    exerciseTime = workSeconds
                }
                
            }
        } else {
            print("Error assigning time.")
            return
        }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func exerciseTimerFires(_ sender: Any)
    {
        if workoutDuration != workoutTimeCap {
            exerciseDuration += 1
            
            timerLabel.text = timeString(time: exerciseDuration)
            
            if exerciseDuration >= exerciseTime! {
                completed += 1
                
                if self.currentWorkout?.type == "EMOM" {
                    nextEMOMexercise()
                    exerciseDuration = 0.0
                } else if self.currentWorkout?.type == "TABATA" {
                    nextTABATAperiod()
                    exerciseDuration = 0.0
                    
                }
            }
        }  else {
            timerLabel.text = nil
            secondaryTimer = nil
            secondaryTimer?.invalidate()
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
            case "AMRAP", "FOR TIME":
                self.forTimeAMRAPSetup()
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
            if countdownTimer == nil {
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

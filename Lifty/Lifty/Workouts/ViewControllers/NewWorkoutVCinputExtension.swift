//
//  NewWorkoutVCinputExtension.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

extension NewWorkoutVC {
    
    //    MARK: Input handling.
    
    @objc func checkInput (sender: UIBarButtonItem) {
        
        var isValid = true
        
        if chosenWorkout.name != "" {
            let user = Auth.auth().currentUser
            if let user = user {
                let workoutDocument = WorkoutDocument(uid: user.uid)
                workoutDocument.deleteWorkoutDocument(workout: self.chosenWorkout)
            }
        }
        
        //        fix indexes
        for (index, exercise) in self.chosenWorkout.exercises.enumerated() {
            print(String(exercise.exerciseIndex))
            print(exercise.exerciseName)
            exercise.exerciseIndex = index
        }
        
        isValid = self.getTitle()
        
        //        getting workout type and specyfics
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "workoutTypes")
        chosenWorkout.type = typeRow!.value!
        
        switch self.chosenWorkout.type {
        case "FOR TIME":
            isValid = self.getForTimeData()
        case "EMOM":
            isValid = self.getEmomData()
        case "AMRAP":
            isValid = self.getAmrapData()
        case "TABATA":
            isValid = self.getTabataData()
        default:
            print("Unknown type")
        }
        
        print(isValid)
        if !isValid {
            AlertView.showInvalidDataAlert(view: self, theme: UIColor.systemIndigo)
        } else {
            //            add data to Cloud Firestore
            let user = Auth.auth().currentUser
            if let user = user {
                let workoutDocument = WorkoutDocument(uid: user.uid)
                workoutDocument.setWorkoutDocument(workout: self.chosenWorkout, completion: {
                    let rootVC = self.navigationController!.viewControllers.first as! WorkoutsVC
                    rootVC.initiateForm()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                })
            }
        }
        
    }
    
    //    MARK: Input validation.
    
    func getTitle () -> Bool {
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        if titleRow!.value == nil {
            return false
        } else {
            self.chosenWorkout.name = titleRow!.value!
            return true
        }
    }
    
    func getForTimeData () -> Bool {
        let timeRow: IntRow? = form.rowBy(tag: "forTimeTime")
        let roundsRow: IntRow? = form.rowBy(tag: "forTimeRounds")
        if timeRow!.value == nil || roundsRow!.value == nil {
            return false
        } else {
            self.chosenWorkout.restTime = ""
            self.chosenWorkout.time = String(describing: timeRow!.value!)
            self.chosenWorkout.rounds = roundsRow!.value!
            return true
        }
    }
    
    func getEmomData () -> Bool {
        let timeRow: PickerInputRow<String>? = form.rowBy(tag: "EMOMTime")
        let roundsRow: IntRow? = form.rowBy(tag: "EMOMRounds")
        if timeRow!.value == nil || roundsRow!.value == nil {
            return false
        } else {
            self.chosenWorkout.time = timeRow!.value!
            self.chosenWorkout.rounds = roundsRow!.value!
            self.chosenWorkout.restTime = ""
            return true
        }
    }
    
    func getAmrapData () -> Bool {
        let timeRow: IntRow? = form.rowBy(tag: "AMRAPTime")
        if timeRow!.value == nil {
            return false
        } else {
            self.chosenWorkout.time = String(describing: timeRow!.value!)
            self.chosenWorkout.restTime = ""
            self.chosenWorkout.rounds = 0
            return true
        }
    }
    
    func getTabataData () -> Bool {
        let roundsRow: IntRow? = form.rowBy(tag: "TabataRounds")
        let timeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataTime")
        let restTimeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataRestTime")
        if roundsRow!.value == nil || timeRow!.value == nil || restTimeRow!.value == nil {
            return false
        } else {
            self.chosenWorkout.rounds = roundsRow!.value!
            self.chosenWorkout.time = timeRow!.value!
            self.chosenWorkout.restTime = restTimeRow!.value!
            return true
        }
    }
}

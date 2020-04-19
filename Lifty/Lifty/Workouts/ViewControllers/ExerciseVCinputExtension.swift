//
//  ExerciseVCinputExtension.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import Eureka

extension ExerciseVC {
    
    //    MARK: Input handling.
    
    @objc func checkInput (sender: UIBarButtonItem){
        
        var isValid = true
        
        isValid = getExerciseName()
        
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "exerciseType")
        self.chosenExercise.exerciseType = typeRow!.value!
        
        if self.chosenExercise.exerciseType == "Time" {
            isValid = getForTimeExerciseData()
        }
        else if self.chosenExercise.exerciseType == "Reps" {
            isValid = getForRepsExerciseData()
        }
        
        let noteRow: TextAreaRow? = form.rowBy(tag: "Notes")
        if (noteRow!.value != nil && noteRow!.value != "") {
            self.chosenExercise.notes = noteRow!.value!
        }
        
        if !isValid {
            AlertView.showInvalidDataAlert(view: self, theme: UIColor.systemIndigo)
        } else {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //    MARK: Input validation.
    
    func getExerciseName () -> Bool {
        let nameRow: TextRow? = form.rowBy(tag: "Name")
        if nameRow!.value == nil {
            return false
        } else {
            self.chosenExercise.exerciseName = nameRow!.value!
            return true
        }
    }
    
    func getForTimeExerciseData () -> Bool {
        self.chosenExercise.reps = 0
        let timeRow: PickerInputRow<String>? = form.rowBy(tag: "Time: ")
        if timeRow!.value == nil {
            return false
        } else {
            self.chosenExercise.exerciseTime = timeRow!.value!
            self.chosenRow?.title = self.chosenExercise.exerciseName + " " +  String(self.chosenExercise.exerciseTime)
            return true
        }
    }
    
    func getForRepsExerciseData () -> Bool {
        self.chosenExercise.exerciseTime = "-"
        let repsRow: IntRow? = form.rowBy(tag: "Amout of reps")
        if repsRow!.value == nil {
            return false
        } else {
            self.chosenExercise.reps = repsRow!.value!
            self.chosenRow?.title = self.chosenExercise.exerciseName + " " +  String(self.chosenExercise.reps)
            return true
        }
    }
    
}

//
//  Exercise.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 18/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class AlertHelper {
    func showAlert(fromController controller: FormViewController) {
        let unfilledAlert = UIAlertController(title: "Please fill out missing fields.", message: "", preferredStyle: UIAlertController.Style.alert)
        unfilledAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(unfilledAlert, animated: true, completion: nil)
    }
}

class ExerciseVC: FormViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createForm ()
    }
    

    func createForm () {
        
         form +++

               TextRow("Name").cellSetup { cell, row in
                if chosenExercise.exerciseName != "" {
                    print(chosenExercise.exerciseName)
                    cell.textField.text = chosenExercise.exerciseName
                }
                else {
                    cell.textField.placeholder = row.tag
                }
               }
        form +++
            Section()
        <<< SegmentedRow<String>("exerciseType"){
                $0.options = ["Reps", "Time"]
                $0.value = "Reps"
            }
            +++ Section(){
                $0.tag = "reps_t"
                $0.hidden = "$exerciseType != 'Reps'" // .Predicate(NSPredicate(format: "$segments != 'Reps'"))
            }
            
            <<< IntRow() {
                $0.tag = "Amout of reps"
                $0.title = "Amout of reps"
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            let indexPath = row.indexPath!.row + index + 1
                            row.section?.insert(labelRow, at: indexPath)
                        }
                    }
            }

            +++ Section(){
                $0.tag = "time_t"
                $0.hidden = "$exerciseType != 'Time'"
            }
            <<< PickerInputRow<String>(){
                $0.tag = "Time: "
                $0.title = "Time: "
                $0.options = []
                
                $0.options.append("-")

                var minutes = 0, seconds = 10
                 while minutes <= 4 {
                    if seconds == 0 {
                        $0.options.append("\(minutes):\(seconds)0")
                    }
                    else {
                        $0.options.append("\(minutes):\(seconds)")
                    }
                    seconds = seconds + 10
                    if seconds == 60 {
                        minutes += 1
                        seconds = 0
                    }
                 }
                $0.options.append("\(minutes):\(seconds)0")
                $0.value = $0.options.first
            }
            
            +++ Section()

            <<< TextAreaRow() {
                $0.tag = "Notes"
                $0.placeholder = "Additional notes (weight used, technique etc.)."
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let modifiedExercise = self.manageInput()
        globalNewWorkoutVC!.isModified(modifiedExercise: modifiedExercise)
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func manageInput () -> (Exercise) {
        
        let alert = AlertHelper()
        var reps: Int? = nil
        var time: String? = nil
        var exerciseName: String? = nil
        
//        getting exercise name
        
        let nameRow: TextRow? = form.rowBy(tag: "Name")
        if nameRow!.value == nil {
            alert.showAlert(fromController: self)
        }
        else {
            exerciseName = nameRow!.value
        }
        
//        getting exercise type
        
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "exerciseType")
        let exerciseType = typeRow!.value
        
//        getting time/reps
        
        if exerciseType == "Time" {
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "Time: ")
            if timeRow!.value == "-" {
                alert.showAlert(fromController: self)
            }
            else {
                time = timeRow!.value
            }
        }
        else if exerciseType == "Reps" {
            let repsRow: IntRow? = form.rowBy(tag: "Amout of reps")
            if repsRow!.value == nil {
                alert.showAlert(fromController: self)
            }
            else {
                reps = repsRow!.value
            }
        }
        
//        getting notes
        
        let noteRow: TextAreaRow? = form.rowBy(tag: "Notes")
        let notes = noteRow!.value
        
//        creating the object
        
        let modifiedExercise = Exercise (exerciseName: exerciseName!, exerciseIndex: 0)
        modifiedExercise.exerciseType = exerciseType
        modifiedExercise.reps = reps
        modifiedExercise.exerciseTime = time
        modifiedExercise.notes = notes
        
        return modifiedExercise
    }
}

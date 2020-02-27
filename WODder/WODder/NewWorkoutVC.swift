//
//  NewWorkout.swift
//  WODder
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var exerciseIndex: Int = 0
var chosenCell: ButtonCellOf<String>?
var chosenRow: ButtonRowOf<String>?
var rowTitles: [String] =  []

class NewWorkoutVC: FormViewController {
    
    @IBOutlet weak var triggerButton: UIButton!
    
    var workoutTypes =  ["AMRAP","EMOM","for time","tabata"]
    let workout = Workout()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        createWorkoutTitleForm()
        createWorkoutTypeForm()
        createExercisesForm()

    }
    
    
    func createWorkoutTitleForm () {
            
            form +++

                  TextRow("Title").cellSetup { cell, row in
                    cell.textField.placeholder = row.tag
                  }
    }
        
    func createWorkoutTypeForm () {
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }

        form +++
            Section()
            <<< SegmentedRow<String>("workoutTypes"){
                $0.options = ["FOR TIME", "EMOM", "AMRAP", "TABATA"]
                $0.value = "FOR TIME"
            }
            +++ Section(){
                $0.tag = "for_time_t"
                $0.hidden = "$workoutTypes != 'FOR TIME'" // .Predicate(NSPredicate(format: "$segments != 'FOR TIME'"))
            }
            
            <<< IntRow() {
                $0.title = "Time cap:"
                $0.placeholder = "in minutes"
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

            <<< IntRow() {
                $0.title = "Rounds:"
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
                $0.tag = "emom_t"
                $0.hidden = "$workoutTypes != 'EMOM'"
            }
            <<< PickerInputRow<String>(){
                $0.title = "Every: "
                $0.options = []

                var minutes = 0, seconds = 15
                 while minutes <= 10 {
                    if seconds == 0 {
                        $0.options.append("\(minutes):\(seconds)0")
                    }
                    else {
                        $0.options.append("\(minutes):\(seconds)")
                    }
                    seconds = seconds + 15
                    if seconds == 60 {
                        minutes += 1
                        seconds = 0
                    }
                 }
                $0.options.append("\(minutes):\(seconds)0")
                $0.value = $0.options.first
            }

            <<< IntRow() {
                $0.title = "Rounds: "
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
                $0.tag = "amrap_t"
                $0.hidden = "$workoutTypes != 'AMRAP'"
            }
            <<< IntRow() {
                $0.title = "Time cap: "
                $0.placeholder = "in minutes"
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
            $0.tag = "tabata_t"
            $0.hidden = "$workoutTypes != 'TABATA'"
        }
        <<< IntRow() {
            $0.title = "Rounds:"
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

        <<< PickerInputRow<String>(){
            $0.title = "Work: "
            $0.options = []

            var minutes = 0, seconds = 15
             while minutes <= 14 {
                if seconds == 0 {
                    $0.options.append("\(minutes):\(seconds)0")
                }
                else {
                    $0.options.append("\(minutes):\(seconds)")
                }
                seconds = seconds + 15
                if seconds == 60 {
                    minutes += 1
                    seconds = 0
                }
             }
            $0.options.append("\(minutes):\(seconds)0")
            $0.value = $0.options.first
        }
        
        <<< PickerInputRow<String>(){
            $0.title = "Rest: "
            $0.options = []

            var minutes = 0, seconds = 15
             while minutes <= 14 {
                if seconds == 0 {
                    $0.options.append("\(minutes):\(seconds)0")
                }
                else {
                    $0.options.append("\(minutes):\(seconds)")
                }
                seconds = seconds + 15
                if seconds == 60 {
                    minutes += 1
                    seconds = 0
                }
             }
            $0.options.append("\(minutes):\(seconds)0")
            $0.value = $0.options.first
        }
    }
    
    func createExercisesForm () {
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete]) {
                                $0.tag = "exercises"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add another exercise"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return ButtonRow () {
                                        rowTitles.append("Exercise \(index+1)")
                                        $0.title = rowTitles[index]
                                        $0.value = "tap to edit"
                                        $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                                        $0.onCellSelection(self.buttonTapped)
                                        let newExercise = Exercise(exerciseName: rowTitles[index], exerciseIndex: index+1)
                                        self.workout.addExercise(exercise: newExercise)
                                    }
                                }
                                $0  <<< ButtonRow () {
                                    rowTitles.append("Exercise 1")
                                    $0.title = rowTitles[0]
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                                    $0.onCellSelection(self.buttonTapped)
                                    let newExercise = Exercise(exerciseName: rowTitles[0], exerciseIndex: 1)
                                    self.workout.addExercise(exercise: newExercise)
                                }
            }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        exerciseIndex = row.indexPath!.row + 1
        chosenCell = cell
        chosenRow = row
    }
    
    func isModified(modifiedExercise: Exercise) {
        
        for exercise in workout.exercises {
            if exercise.exerciseIndex == exerciseIndex {
                exercise.assign(exerciseToAssign: modifiedExercise)
            }
        }
        
        rowTitles[exerciseIndex-1] = modifiedExercise.exerciseName
        chosenRow?.title = modifiedExercise.exerciseName
        chosenRow!.updateCell()
        
    }
    
//    detect reordering and correct data
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let firstToSwap = Exercise(exerciseName: "", exerciseIndex: 0)
        let secondToSwap = Exercise(exerciseName: "", exerciseIndex: 0)
        let dummy = Exercise(exerciseName: "", exerciseIndex: 0)
        
        for exercise in workout.exercises {
            if exercise.exerciseIndex == sourceIndexPath[1]+1 {
                firstToSwap.assign(exerciseToAssign: exercise)
            }
            if exercise.exerciseIndex == destinationIndexPath[1]+1 {
                secondToSwap.assign(exerciseToAssign: exercise)
                dummy.assign(exerciseToAssign: exercise)
            }
        }
        workout.exercises[secondToSwap.exerciseIndex-1].assign(exerciseToAssign: firstToSwap)
        workout.exercises[firstToSwap.exerciseIndex-1].assign(exerciseToAssign: dummy)
        
    }
    
//    detect deletion
    

    
//    save workout data upon view dismissal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        SavedWODsVC().addWorkout(workout: workout)
    }
    
}

//
//  NewWorkout.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var exerciseIndex: Int = 0
var chosenCell: ButtonCellOf<String>?
var chosenRow: ButtonRowOf<String>?

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
            
            <<< IntRow("forTimeTime") {
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

            <<< IntRow("forTimeRounds") {
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
            <<< PickerInputRow<String>("EMOMTime"){
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

            <<< IntRow("EMOMRounds") {
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
            <<< IntRow("AMRAPTime") {
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
        <<< IntRow("TabataRounds") {
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

        <<< PickerInputRow<String>("TabataTime"){
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
        
        <<< PickerInputRow<String>("TabataRestTime"){
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
                                        $0.title = "Exercise"
                                        $0.value = "tap to edit"
                                        $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                                        $0.onCellSelection(self.buttonTapped)
                                        let newExercise = Exercise(exerciseName: "Workout", exerciseIndex: index+1)
                                        self.workout.addExercise(exercise: newExercise)
                                        
                                        let deleteAction = SwipeAction(
                                                     style: .destructive,
                                                     title: "Delete",
                                                     handler: { (action, row, completionHandler) in
                                                         self.deleteExercise(index: row.indexPath!.row)
                                                         completionHandler?(true)
                                                     })

                                                 $0.trailingSwipe.actions = [deleteAction]
                                                 $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                                    }
                                }
                                $0  <<< ButtonRow () {
                                    $0.title = "Exercise"
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                                    $0.onCellSelection(self.buttonTapped)
                                    let newExercise = Exercise(exerciseName: "Workout", exerciseIndex: 1)
                                    self.workout.addExercise(exercise: newExercise)
                                    
                                    let deleteAction = SwipeAction(
                                                 style: .destructive,
                                                 title: "Delete",
                                                 handler: { (action, row, completionHandler) in
                                                    self.deleteExercise(index: row.indexPath!.row)
                                                    completionHandler?(true)
                                                 })

                                             $0.trailingSwipe.actions = [deleteAction]
                                             $0.trailingSwipe.performsFirstActionWithFullSwipe = true
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
    
    
//    handle deletion
    
    func deleteExercise (index: Int) {
        workout.exercises.remove(at: index)
        for exercise in workout.exercises {
            print(exercise.exerciseIndex)
        }
    }
    
//    save workout data upon view dismissal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        fix indexes
        for (index, exercise) in workout.exercises.enumerated() {
            exercise.exerciseIndex = index
        }
                
//        getting workout title
                
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        workout.name = titleRow?.value ?? "Workout"
                
//        getting workout type and specyfics
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "workoutTypes")
        workout.type = typeRow!.value
        
        if workout.type == "for time" {
            let timeRow: IntRow? = form.rowBy(tag: "forTimeTime")
            workout.time = timeRow!.value
            workout.time = workout.time! * 60
            let roundsRow: IntRow? = form.rowBy(tag: "forTimeRounds")
            workout.rounds = roundsRow!.value
        }
        if workout.type == "EMOM" {
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "EMOMTime")
            let time = pickerRowStringToInt(timeToConvert: timeRow!.value)
            workout.time = time
            let roundsRow: IntRow? = form.rowBy(tag: "EMOMRounds")
            workout.rounds = roundsRow!.value
        }
        if workout.type == "AMRAP" {
            let timeRow: IntRow? = form.rowBy(tag: "AMRAPTime")
            workout.time = timeRow!.value
            workout.time = workout.time! * 60
        }
        if workout.type == "tabata" {
            let roundsRow: IntRow? = form.rowBy(tag: "TabataRounds")
            workout.rounds = roundsRow!.value
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataTime")
            let time = pickerRowStringToInt(timeToConvert: timeRow!.value)
            workout.time = time
            let restTimeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataRestTime")
            let restTime = pickerRowStringToInt(timeToConvert: restTimeRow!.value)
            workout.restTime = restTime
        }
        
        SavedWorkoutsVC().changeWorkoutData(workout: workout)
    }
    
    func pickerRowStringToInt (timeToConvert: String?) -> Int {
        var minutes: Int
        if (timeToConvert!.count == 4) {
            minutes = Int(timeToConvert!.prefix(1))!
        }
        else {
            minutes = Int(timeToConvert!.prefix(2))!
        }
        let seconds = Int(timeToConvert!.suffix(2))!

        return minutes * 60 + seconds
    }
    
}

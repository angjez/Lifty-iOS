//
//  NewWorkout.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka

var globalNewWorkoutVC: NewWorkoutVC?

class NewWorkoutVC: FormViewController {
    
    @IBOutlet weak var triggerButton: UIButton!
    
    var workoutTypes =  ["AMRAP","EMOM","for time","tabata"]
    let workout = Workout(name: "New")
    var exerciseIndex: Int = 0
    var chosenCell: ButtonCellOf<String>?
    var chosenRow: ButtonRowOf<String>?
    var chosenExercise = Exercise(exerciseIndex: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalNewWorkoutVC = self as! NewWorkoutVC
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.systemIndigo
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        createWorkoutTitleForm()
        createWorkoutTypeForm()
        createExercisesForm()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let tabBarController = self.tabBarController
            else {
                print("Error initializing tab bar controller!")
                return
        }
        guard let navigationController = self.navigationController
            else {
                print("Error initializing navigation controller!")
                return
        }
        
        setBlueGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
    }
    
    func createWorkoutTitleForm () {
        
        form +++
            
            TextRow("Title").cellSetup { cell, row in
            }.cellUpdate { cell, row in
                if (globalSavedWorkoutsVC!.chosenWorkout.name != "Workout" && globalSavedWorkoutsVC!.chosenWorkout.name != "") {
                    cell.textField!.placeholder = globalSavedWorkoutsVC!.chosenWorkout.name
                    row.value = globalSavedWorkoutsVC!.chosenWorkout.name
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                cell.textField!.textColor = UIColor.systemIndigo
                cell.indentationLevel = 2
                cell.indentationWidth = 10
                let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
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
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                if globalSavedWorkoutsVC!.chosenWorkout.type != "" {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.type
                }
                else {
                    $0.value = "FOR TIME"
                }
            }
            +++ Section(){
                $0.tag = "for_time_t"
                $0.hidden = "$workoutTypes != 'FOR TIME'" // .Predicate(NSPredicate(format: "$segments != 'FOR TIME'"))
            }
            
            <<< IntRow("forTimeTime") {
                $0.add(rule: RuleRequired())
                $0.title = "Time cap:"
                if (globalSavedWorkoutsVC!.chosenWorkout.time != "-") {
                    $0.value = Int(globalSavedWorkoutsVC!.chosenWorkout.time)
                }
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
                $0.add(rule: RuleRequired())
                $0.title = "Rounds:"
                if (globalSavedWorkoutsVC!.chosenWorkout.rounds != 0) {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.rounds
                }
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
                if (globalSavedWorkoutsVC!.chosenWorkout.time != "-") {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.time
                }
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
                $0.add(rule: RuleRequired())
                $0.title = "Rounds: "
                if (globalSavedWorkoutsVC!.chosenWorkout.rounds != 0) {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.rounds
                }
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
                $0.add(rule: RuleRequired())
                $0.title = "Time cap: "
                if (globalSavedWorkoutsVC!.chosenWorkout.time != "-") {
                    $0.value = Int(globalSavedWorkoutsVC!.chosenWorkout.time)
                }
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
                $0.add(rule: RuleRequired())
                $0.title = "Rounds:"
                if (globalSavedWorkoutsVC!.chosenWorkout.rounds != 0) {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.rounds
                }
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
                if (globalSavedWorkoutsVC!.chosenWorkout.time != "-") {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.time
                }
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
                if (globalSavedWorkoutsVC!.chosenWorkout.restTime != "-") {
                    $0.value = globalSavedWorkoutsVC!.chosenWorkout.restTime
                }
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
        let deleteAction = SwipeAction(
            style: .destructive,
            title: "Delete",
            handler: { (action, row, completionHandler) in
                self.deleteExercise(index: row.indexPath!.row)
                completionHandler?(true)
        })
        deleteAction.actionBackgroundColor = .lightGray
        deleteAction.image = UIImage(systemName: "trash")
        
        form +++ Section()
        
        form +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
                $0.tag = "exercises"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Add another exercise"
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textAlignment = .left
                        cell.textLabel?.textColor = UIColor.lightGray
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return ButtonRow () {
                        
                        $0.title = "Exercise"
                        $0.value = "tap to edit"
                        let newExercise = Exercise(exerciseIndex: index+1)
                        newExercise.reps = 0
                        newExercise.notes = ""
                        newExercise.exerciseTime = ""
                        self.workout.exercises.append(newExercise)
                        
                        $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                        $0.onCellSelection(self.selected)
                        
                        
                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }
                }
                if (globalSavedWorkoutsVC!.chosenWorkout.exercises.isEmpty) {
                    $0  <<< ButtonRow () {
                        
                        $0.title = "Exercise"
                        $0.value = "tap to edit"
                        let newExercise = Exercise(exerciseIndex: 1)
                        newExercise.reps = 0
                        newExercise.notes = ""
                        newExercise.exerciseTime = ""
                        self.workout.exercises.append(newExercise)
                        
                        $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                        $0.onCellSelection(self.selected)
                        
                        
                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }
                }
                for exercise in globalSavedWorkoutsVC!.chosenWorkout.exercises {
                    $0  <<< ButtonRow () {
                        if (exercise.exerciseType == "Reps") {
                            $0.title = exercise.exerciseName + " " +  String(exercise.reps)
                        } else {
                            $0.title = exercise.exerciseName + " " +  exercise.exerciseTime
                        }
                        $0.value = "tap to edit"
                        self.workout.exercises.append(exercise)
                        $0.presentationMode = .segueName(segueName: "ExerciseSegue", onDismiss: nil)
                        $0.onCellSelection(self.selected)
                        
                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }
                }
        }
    }
    
    func selected(cell: ButtonCellOf<String>, row: ButtonRow) {
        exerciseIndex = row.indexPath!.row
        chosenCell = cell
        chosenRow = row
        for exercise in workout.exercises {
            if exercise.exerciseIndex == exerciseIndex {
                chosenExercise.assign(exerciseToAssign: exercise);
            }
        }
    }
    
    func isModified(modifiedExercise: Exercise) {
        for exercise in workout.exercises {
            if exercise.exerciseIndex == exerciseIndex {
                exercise.assign(exerciseToAssign: modifiedExercise)
                if chosenExercise.exerciseType == "Reps" {
                    chosenRow?.title = exercise.exerciseName + String(exercise.reps)
                } else {
                    chosenRow?.title = exercise.exerciseName + exercise.exerciseTime
                }
                chosenRow!.updateCell()
                break
                
            }
        }
    }
    
    //    handle deletion
    
    func deleteExercise (index: Int) {
        workout.exercises.remove(at: index)
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
        workout.name = titleRow!.value!
        
        //        getting workout type and specyfics
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "workoutTypes")
        workout.type = typeRow!.value!
        
        if workout.type == "FOR TIME" {
            let timeRow: IntRow? = form.rowBy(tag: "forTimeTime")
            workout.time = String(describing: timeRow!.value!)
            let roundsRow: IntRow? = form.rowBy(tag: "forTimeRounds")
            workout.rounds = roundsRow!.value!
            
            workout.restTime = ""
        }
        if workout.type == "EMOM" {
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "EMOMTime")
            workout.time = timeRow!.value!
            let roundsRow: IntRow? = form.rowBy(tag: "EMOMRounds")
            workout.rounds = roundsRow!.value!
            
            workout.restTime = ""
        }
        if workout.type == "AMRAP" {
            let timeRow: IntRow? = form.rowBy(tag: "AMRAPTime")
            workout.time = String(describing: timeRow?.value)
            
            workout.restTime = ""
            workout.rounds = 0
        }
        if workout.type == "TABATA" {
            let roundsRow: IntRow? = form.rowBy(tag: "TabataRounds")
            workout.rounds = roundsRow!.value!
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataTime")
            workout.time = timeRow!.value!
            let restTimeRow: PickerInputRow<String>? = form.rowBy(tag: "TabataRestTime")
            workout.restTime = restTimeRow!.value!
        }
        
        globalSavedWorkoutsVC!.changeWorkoutData(modifiedWorkout: workout)
    }
    
}

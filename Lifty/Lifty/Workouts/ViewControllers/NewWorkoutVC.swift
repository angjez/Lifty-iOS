//
//  NewWorkout.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka

class NewWorkoutVC: FormViewController, passWorkout {
    
    var newWorkoutDelegate: passExercise?

    
    let viewCustomisation = ViewCustomisation()
    
    var exerciseIndex: Int = 0
    var chosenRow: ButtonRowOf<String>?
    var chosenExercise = Exercise(exerciseIndex: 0)
    
    var chosenWorkout = Workout(name: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.replaceBackButton()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        
        createWorkoutTitleForm()
        createWorkoutTypeForm()
        createExercisesForm()
        
    }
    
    func replaceBackButton () {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkInput(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewCustomisation.setBlueGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenWorkout: Workout) {
        self.chosenWorkout = chosenWorkout
        print("finished passing")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ExerciseVC{
            self.newWorkoutDelegate = destinationVC
            self.newWorkoutDelegate?.finishPassing(chosenExercise: self.chosenExercise, chosenRow: self.chosenRow)
        }
    }
    
    //    MARK: Form handling.
    
    func createWorkoutTitleForm () {
        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
        form +++
            
            TextRow("Title").cellSetup { cell, row in
                row.add(rule: RuleRequired())
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
                if (self.chosenWorkout.name != "Workout" && self.chosenWorkout.name != "") {
                    cell.textField!.placeholder = self.chosenWorkout.name
                    row.value = self.chosenWorkout.name
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                cell.textField!.textColor = UIColor.systemIndigo
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
            }.onRowValidationChanged { cell, row in
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
                if self.chosenWorkout.type != "" {
                    $0.value = self.chosenWorkout.type
                }
                else {
                    $0.value = "FOR TIME"
                }
            }
            +++ Section(){
                $0.tag = "for_time_t"
                $0.hidden = "$workoutTypes != 'FOR TIME'"
            }
            
            <<< IntRow("forTimeTime") {
                $0.add(rule: RuleRequired())
                $0.title = "Time cap:"
                if (self.chosenWorkout.time != "-") {
                    $0.value = Int(self.chosenWorkout.time)
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.textLabel?.textColor = .systemIndigo
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
                if (self.chosenWorkout.rounds != 0) {
                    $0.value = self.chosenWorkout.rounds
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.textLabel?.textColor = .systemIndigo
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
                if (self.chosenWorkout.time != "-") {
                    $0.value = self.chosenWorkout.time
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
            }.cellUpdate { cell, row in
                cell.textLabel?.textColor = .systemIndigo
            }
            
            <<< IntRow("EMOMRounds") {
                $0.add(rule: RuleRequired())
                $0.title = "Rounds: "
                if (self.chosenWorkout.rounds != 0) {
                    $0.value = self.chosenWorkout.rounds
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.textLabel?.textColor = .systemIndigo
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
                if (self.chosenWorkout.time != "-") {
                    $0.value = Int(self.chosenWorkout.time)
                }
                $0.placeholder = "in minutes"
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.textLabel?.textColor = .systemIndigo
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
                if (self.chosenWorkout.rounds != 0) {
                    $0.value = self.chosenWorkout.rounds
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.textLabel?.textColor = .systemIndigo
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
                if (self.chosenWorkout.time != "-") {
                    $0.value = self.chosenWorkout.time
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
            }.cellUpdate { cell, row in
                cell.textLabel?.textColor = .systemIndigo
            }
            
            <<< PickerInputRow<String>("TabataRestTime"){
                $0.title = "Rest: "
                if (self.chosenWorkout.restTime != "-") {
                    $0.value = self.chosenWorkout.restTime
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
            }.cellUpdate { cell, row in
                cell.textLabel?.textColor = .systemIndigo
        }
    }
    
    func createExercisesForm () {
        let deleteAction = SwipeAction(
            style: .destructive,
            title: "Delete",
            handler: { (action, row, completionHandler) in
                self.chosenWorkout.exercises.remove(at: row.indexPath!.row)
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
                        $0.title = "Add an exercise"
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textAlignment = .left
                        cell.textLabel?.textColor = UIColor.lightGray
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return ButtonRow () {
                        $0.title = "Exercise"
                        let newExercise = Exercise(exerciseIndex: index)
                        newExercise.reps = 0
                        newExercise.notes = ""
                        newExercise.exerciseTime = ""
                        self.chosenWorkout.exercises.append(newExercise)
                        
                        $0.onCellSelection(self.selected)
                        
                        
                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textColor = UIColor.systemIndigo
                        cell.indentationLevel = 2
                        cell.indentationWidth = 10
                        cell.textLabel!.textAlignment = .left
                    }
                }
                for exercise in self.chosenWorkout.exercises {
                    $0  <<< ButtonRow () {
                        if (exercise.exerciseType == "Reps") {
                            $0.title = exercise.exerciseName + " " +  String(exercise.reps)
                        } else if (exercise.exerciseType == "Time") {
                            $0.title = exercise.exerciseName + " " +  exercise.exerciseTime
                        }
                        self.chosenWorkout.exercises.append(exercise)
                        $0.onCellSelection(self.selected)
                        $0.trailingSwipe.actions = [deleteAction]
                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textColor = UIColor.systemIndigo
                        cell.indentationLevel = 2
                        cell.indentationWidth = 10
                        cell.textLabel!.textAlignment = .left
                    }
                }
        }
    }
    
    func selected(cell: ButtonCellOf<String>, row: ButtonRow) {
        exerciseIndex = row.indexPath!.row
        chosenRow = row
        self.chosenExercise = self.chosenWorkout.exercises[exerciseIndex]
        self.performSegue(withIdentifier: "ExerciseSegue", sender: self)
    }
    
}

//
//  Exercise.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 18/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class ExerciseVC: FormViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        
        setGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
        
        createForm ()
    }
    
    
    func createForm () {
        
        form +++
            
            TextRow("Name").cellSetup { cell, row in
            } .cellUpdate { cell, row in
                if chosenExercise.exerciseName != "" && chosenExercise.exerciseName != "Exercise" {
                    cell.textField.text = chosenExercise.exerciseName
                    row.value = chosenExercise.exerciseName
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                cell.textField!.textColor = UIColor.systemIndigo
                cell.indentationLevel = 2
                cell.indentationWidth = 10
                let flareGradientImage = CAGradientLayer.primaryGradient(on: self.view)
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: flareGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
        }
        form +++
            Section()
            <<< SegmentedRow<String>("exerciseType"){
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                $0.options = ["Reps", "Time"]
                if (chosenExercise.exerciseType == "Time") {
                    $0.value = "Time"
                }
                else {
                    $0.value = "Reps"
                }
            }
            +++ Section(){
                $0.tag = "reps_t"
                $0.hidden = "$exerciseType != 'Reps'" // .Predicate(NSPredicate(format: "$segments != 'Reps'"))
            }
            
            <<< IntRow() {
                $0.tag = "Amout of reps"
                $0.title = "Amout of reps"
                if (chosenExercise.exerciseType == "Reps") {
                    $0.value = chosenExercise.reps
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    row.cell.layer.borderWidth = 3.0
                    row.cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                row.cell.layer.borderWidth = 3.0
                row.cell.layer.borderColor = UIColor.lightGray.cgColor
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    row.cell.layer.borderWidth = 3.0
                    row.cell.layer.borderColor = UIColor.lightGray.cgColor
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
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                $0.tag = "Time: "
                $0.title = "Time: "
                $0.options = []
                if (chosenExercise.exerciseType == "Time") {
                    $0.value = chosenExercise.exerciseTime
                }
                
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
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                if (chosenExercise.notes != nil) {
                    $0.value = chosenExercise.notes
                }
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
        
        var reps: Int? = nil
        var time: String? = nil
        var exerciseName: String? = nil
        
        //        getting exercise name
        
        let nameRow: TextRow? = form.rowBy(tag: "Name")
        exerciseName = nameRow!.value
        
        //        getting exercise type
        
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "exerciseType")
        let exerciseType = typeRow!.value
        
        //        getting time/reps
        
        if exerciseType == "Time" {
            reps = 0
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "Time: ")
            time = timeRow!.value
            
        }
        else if exerciseType == "Reps" {
            time = "-"
            let repsRow: IntRow? = form.rowBy(tag: "Amout of reps")
            reps = repsRow!.value
        }
        
        //        getting notes
        
        let noteRow: TextAreaRow? = form.rowBy(tag: "Notes")
        var notes = ""
        if (noteRow!.value != nil && noteRow!.value != "") {
            notes = noteRow!.value!
        }
        
        //        creating the object
        
        let modifiedExercise = Exercise (exerciseIndex: 0)
        modifiedExercise.exerciseName = exerciseName!
        modifiedExercise.exerciseType = exerciseType!
        modifiedExercise.reps = reps!
        modifiedExercise.exerciseTime = time!
        modifiedExercise.notes = notes
        
        return modifiedExercise
    }
}

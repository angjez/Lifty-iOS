//
//  Exercise.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 18/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class ExerciseVC: FormViewController, passExercise{
    
    var chosenExercise = Exercise(exerciseIndex: 0)
    var chosenRow: ButtonRowOf<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replaceBackButton()
        
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
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        
        setBlueGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
        
        createTitleForm ()
        createExerciseForm ()
        createNotesForm ()
    }
    
    func replaceBackButton () {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkInput(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    func finishPassing(chosenExercise: Exercise, chosenRow: ButtonRowOf<String>?) {
        self.chosenExercise = chosenExercise
        self.chosenRow = chosenRow
        print("finished passing")
    }
    
    func createTitleForm () {
        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
        form +++
            TextRow("Name").cellSetup { cell, row in
            } .cellUpdate { cell, row in
                if self.chosenExercise.exerciseName != "" && self.chosenExercise.exerciseName != "Exercise" {
                    cell.textField.placeholder = self.chosenExercise.exerciseName
                    row.value = self.chosenExercise.exerciseName
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                cell.textField!.textColor = UIColor.systemIndigo
                setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
        }
    }
    
    func createExerciseForm () {
        form +++
            Section()
            <<< SegmentedRow<String>("exerciseType"){
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                $0.options = ["Reps", "Time"]
                if (self.chosenExercise.exerciseType == "Time") {
                    $0.value = "Time"
                }
                else {
                    $0.value = "Reps"
                }
            }
            +++ Section(){
                $0.tag = "reps_t"
                $0.hidden = "$exerciseType != 'Reps'"
            }
            
            <<< IntRow() {
                $0.tag = "Amout of reps"
                $0.title = "Amout of reps"
                if (self.chosenExercise.exerciseType == "Reps") {
                    $0.value = self.chosenExercise.reps
                }
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    row.cell.layer.borderWidth = 3.0
                    row.cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.titleLabel?.textColor = .red
                } else {
                    cell.titleLabel?.textColor = .systemIndigo
                }
            }
            .onRowValidationChanged { cell, row in
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
                if (self.chosenExercise.exerciseType == "Time") {
                    $0.value = self.chosenExercise.exerciseTime
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
            }.cellUpdate { cell, row in
                cell.textLabel?.textColor = .systemIndigo
        }
    }
    
    func createNotesForm () {
          form  +++ Section()
            
            <<< TextAreaRow() {
                $0.tag = "Notes"
                $0.cell.layer.borderWidth = 3.0
                $0.cell.layer.borderColor = UIColor.lightGray.cgColor
                if (self.chosenExercise.notes != nil) {
                    $0.value = self.chosenExercise.notes
                }
                $0.placeholder = "Additional notes (weight used, technique etc.)."
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
        }
    }
    
    @objc func checkInput (sender: UIBarButtonItem){
        
        var isValid = true
        
        var reps: Int? = nil
        var time: String? = nil
        var exerciseName: String? = nil
        
        //        getting exercise name
        
        let nameRow: TextRow? = form.rowBy(tag: "Name")
        if nameRow!.value == nil {
            isValid = false
        } else {
            exerciseName = nameRow!.value!
        }
        
        //        getting exercise type
        
        let typeRow: SegmentedRow<String>? = form.rowBy(tag: "exerciseType")
        let exerciseType = typeRow!.value!
        
        //        getting time/reps
        
        if exerciseType == "Time" {
            reps = 0
            let timeRow: PickerInputRow<String>? = form.rowBy(tag: "Time: ")
            if timeRow!.value == nil {
                isValid = false
            } else {
                time = timeRow!.value!
                self.chosenRow?.title = self.chosenExercise.exerciseName + " " +  String(self.chosenExercise.exerciseTime)
            }
        }
        else if exerciseType == "Reps" {
            time = "-"
            let repsRow: IntRow? = form.rowBy(tag: "Amout of reps")
            if repsRow!.value == nil {
                isValid = false
            } else {
            reps = repsRow!.value!
                self.chosenRow?.title = self.chosenExercise.exerciseName + " " +  String(self.chosenExercise.reps)
            }
        }
        
        //        getting notes
        
        let noteRow: TextAreaRow? = form.rowBy(tag: "Notes")
        var notes = ""
        if (noteRow!.value != nil && noteRow!.value != "") {
            notes = noteRow!.value!
        }
        
        if !isValid {
            self.invalidDataAlert()
        } else {
            self.chosenExercise.exerciseName = exerciseName!
            self.chosenExercise.exerciseType = exerciseType
            self.chosenExercise.reps = reps!
            self.chosenExercise.exerciseTime = time!
            self.chosenExercise.notes = notes
            navigationController?.popToRootViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func invalidDataAlert () {
        let alert = UIAlertController(title: "Required fields are empty.", message: "Leave without saving?", preferredStyle: .alert)
        alert.view.tintColor = UIColor.systemIndigo
        
        let leaveAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        })
        alert.addAction(leaveAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

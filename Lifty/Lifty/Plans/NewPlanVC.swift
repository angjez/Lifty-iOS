//
//  NewPlanVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var globalNewPlanVC: NewPlanVC?

class NewPlanVC: FormViewController {
    
    var chosenWeekRow: ButtonRowOf<String>?
    var chosenWeek = Week()
    var chosenWeekIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalNewPlanVC = self as! NewPlanVC
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        createPlanTitleDurationForm()
        createWeekRows()
    }
    
    func createPlanTitleDurationForm () {
        
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        form +++ Section ()
            <<< TextRow("Title").cellSetup { cell, row in
            }.cellUpdate { cell, row in
                if (globalPlansVC!.chosenPlan.name != "Plan" && globalPlansVC!.chosenPlan.name != "") {
                    cell.textField!.placeholder = globalPlansVC!.chosenPlan.name
                    row.value = globalPlansVC!.chosenPlan.name
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                cell.textField!.textColor = UIColor.systemPink
                setLabelRowCellProperties(cell: cell, textColor: UIColor.systemPink, borderColor: UIColor(patternImage: pinkGradientImage!))
        }
        form +++ Section ()
            <<< StepperRow() { row in
                row.tag = "weekStepperRow"
                row.title = "Plan duration (in weeks)"
                if !globalPlansVC!.chosenPlan.weeks.isEmpty {
                    row.value = Cell<Double>.Value(globalPlansVC!.chosenPlan.weeks.count)
                }
                else {
                    row.value = 1
                }
                row.displayValueFor = { value in
                    guard let value = value else { return nil }
                    return "\(Int(value))"
                }
            }.cellSetup{ (cell, row) in
                cell.stepper.stepValue = 1
                cell.stepper.maximumValue = 12
                cell.stepper.minimumValue = 1
            }.cellUpdate { (cell, row) in
                self.weekRowsHaveChanged()
                cell.valueLabel.textColor = UIColor.systemPink
                setLabelRowCellProperties(cell: cell, textColor: UIColor.systemPink, borderColor: UIColor(patternImage: pinkGradientImage!))
        }
    }
    
    func weekRowsHaveChanged() {
        let weekStepperRow: StepperRow? = form.rowBy(tag: "weekStepperRow")
        while Int(weekStepperRow!.value!) > globalPlansVC!.chosenPlan.weeks.count {
            globalPlansVC!.chosenPlan.weeks.append(Week())
            form +++
                ButtonRow () { row in
                    row.title = "Week " + String(globalPlansVC!.chosenPlan.weeks.count)
                    row.tag = String(globalPlansVC!.chosenPlan.weeks.count - 1)
                    row.presentationMode = .segueName(segueName: "weekSegue", onDismiss: nil)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
            }
        }
        while Int(weekStepperRow!.value!) < globalPlansVC!.chosenPlan.weeks.count {
            for (index, row) in self.form.rows.enumerated() {
                if row.tag == String(globalPlansVC!.chosenPlan.weeks.count - 1) {
                    self.form.remove(at: index)
                }
            }
            globalPlansVC!.chosenPlan.weeks.removeLast()
        }
    }
    
    func createWeekRows() {
        let weekStepperRow: StepperRow? = form.rowBy(tag: "weekStepperRow")
        while Int(weekStepperRow!.value!) > globalPlansVC!.chosenPlan.weeks.count {
            globalPlansVC!.chosenPlan.weeks.append(Week())
        }
        for (index, week) in globalPlansVC!.chosenPlan.weeks.enumerated() {
            form +++
                ButtonRow () { row in
                    row.title = "Week " + String(index+1)
                    row.tag = String(index)
                    row.presentationMode = .segueName(segueName: "weekSegue", onDismiss: nil)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
            }
        }
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        globalNewPlanVC!.chosenWeekIndex = Int(row.tag!)
        globalNewPlanVC!.chosenWeek = globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!]
        globalNewPlanVC!.chosenWeekRow = row
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent
        {
            let titleRow: TextRow? = form.rowBy(tag: "Title")
            globalPlansVC?.chosenPlan.name = titleRow!.value!
            globalPlansVC?.initiateForm()
            deletePlan(plan: globalPlansVC!.chosenPlan)
            savePlan(plan: globalPlansVC!.chosenPlan)
        }
        super.viewWillDisappear(animated)
    }
}

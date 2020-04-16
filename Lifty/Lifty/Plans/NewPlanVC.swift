//
//  NewPlanVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class NewPlanVC: FormViewController, passPlan {
    
    var weekDelegate: passWeek?
    var planDelegate: passPlan?
    
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    var chosenWeek = Week()
    var chosenWeekIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        createPlanTitleDurationForm()
        createWeekRows()
    }
    
    func finishPassing(chosenPlan: Plan, chosenPlanIndex: Int?) {
        self.chosenPlan = chosenPlan
        self.chosenPlanIndex = chosenPlanIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WeekVC{
            self.planDelegate = destinationVC
            self.weekDelegate = destinationVC
            self.planDelegate?.finishPassing(chosenPlan: self.chosenPlan, chosenPlanIndex: self.chosenPlanIndex)
            self.weekDelegate?.finishPassing(chosenWeek: self.chosenWeek, chosenWeekIndex: self.chosenWeekIndex)
        }
    }
    
    
    func createPlanTitleDurationForm () {
        
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        form +++ Section ()
            <<< TextRow("Title").cellSetup { cell, row in
            }.cellUpdate { cell, row in
                if (self.chosenPlan.name != "Plan" && self.chosenPlan.name != "") {
                    cell.textField!.placeholder = self.chosenPlan.name
                    row.value = self.chosenPlan.name
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
                if !self.chosenPlan.weeks.isEmpty {
                    row.value = Cell<Double>.Value(self.chosenPlan.weeks.count)
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
        while Int(weekStepperRow!.value!) > self.chosenPlan.weeks.count {
            self.chosenPlan.weeks.append(Week())
            form +++
                ButtonRow () { row in
                    row.title = "Week " + String(self.chosenPlan.weeks.count)
                    row.tag = String(self.chosenPlan.weeks.count - 1)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                    cell.textLabel!.textAlignment = .left
            }
        }
        while Int(weekStepperRow!.value!) < self.chosenPlan.weeks.count {
            for (index, row) in self.form.rows.enumerated() {
                if row.tag == String(self.chosenPlan.weeks.count - 1) {
                    self.form.remove(at: index)
                }
            }
            self.chosenPlan.weeks.removeLast()
        }
    }
    
    func createWeekRows() {
        let weekStepperRow: StepperRow? = form.rowBy(tag: "weekStepperRow")
        while Int(weekStepperRow!.value!) > self.chosenPlan.weeks.count {
            self.chosenPlan.weeks.append(Week())
        }
        for (index, week) in self.chosenPlan.weeks.enumerated() {
            form +++
                ButtonRow () { row in
                    row.title = "Week " + String(index+1)
                    row.tag = String(index)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                    cell.textLabel!.textAlignment = .left
            }
        }
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.chosenWeekIndex = Int(row.tag!)
        self.chosenWeek = self.chosenPlan.weeks[self.chosenWeekIndex!]
        self.performSegue(withIdentifier: "weekSegue", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        self.chosenPlan.name = titleRow!.value!
        deletePlan(plan: self.chosenPlan)
        savePlan(plan: self.chosenPlan)
        print(self.chosenPlan)
        globalPlansVC?.initiateForm()
        super.viewWillDisappear(animated)
    }
}

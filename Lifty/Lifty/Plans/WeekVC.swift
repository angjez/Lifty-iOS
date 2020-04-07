//
//  WeekVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var globalWeekVC: WeekVC?

class WeekVC: FormViewController {
    
    var chosenDayRow: ButtonRowOf<String>?
    var chosenDay = Day()
    var chosenDayIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalWeekVC = self as! WeekVC
        
        self.title =  "Week " + String(globalNewPlanVC!.chosenWeekIndex! + 1)
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.systemPink
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        createTrainingDaysForm()
        createDayRows()
    }
    
    func createTrainingDaysForm () {
        
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        form +++ Section ()
            <<< StepperRow() { row in
                row.tag = "traningDaysStepperRow"
                row.title = "Amount of training days"
                if !globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.isEmpty {
                    row.value = Cell<Double>.Value(globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count)
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
                cell.stepper.maximumValue = 7
                cell.stepper.minimumValue = 1
                cell.indentationLevel = 2
                cell.indentationWidth = 1
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
            }.cellUpdate { (cell, row) in
                self.dayRowsHaveChanged()
                cell.valueLabel.textColor = UIColor.systemPink
                cell.textLabel!.textColor = UIColor.systemPink
        }
    }
    
    func dayRowsHaveChanged() {
        let traningDaysStepperRow: StepperRow? = form.rowBy(tag: "traningDaysStepperRow")
        while Int(traningDaysStepperRow!.value!) > globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count {
            globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.append(Day())
            form +++
                ButtonRow () { row in
                    row.title = "Day " + String(globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count)
                    row.tag = String(globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count - 1)
                    row.presentationMode = .segueName(segueName: "chooseWorkoutSegue", onDismiss: nil)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
            }
        }
        while Int(traningDaysStepperRow!.value!) < globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count {
            for (index, row) in self.form.rows.enumerated() {
                if row.tag == String(globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count - 1) {
                    self.form.remove(at: index)
                }
            }
            globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.removeLast()
        }
    }
    
    func createDayRows() {
        let traningDaysStepperRow: StepperRow? = form.rowBy(tag: "traningDaysStepperRow")
        while Int(traningDaysStepperRow!.value!) > globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.count {
            globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.append(Day())
        }
        for (index, day) in globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days.enumerated() {
            form +++
                ButtonRow () { row in
                    row.title = "Day " + String(index+1)
                    row.tag = String(index)
                    row.presentationMode = .segueName(segueName: "chooseWorkoutSegue", onDismiss: nil)
                    row.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
            }
        }
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        globalWeekVC!.chosenDayIndex = Int(row.tag!)
        globalWeekVC!.chosenDay = globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days[chosenDayIndex!]
        globalWeekVC!.chosenDayRow = row
    }

}

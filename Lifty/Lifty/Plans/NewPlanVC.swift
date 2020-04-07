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
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.systemPink
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
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
                cell.indentationLevel = 2
                cell.indentationWidth = 10
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
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
                cell.indentationLevel = 2
                cell.indentationWidth = 1
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
            }.cellUpdate { (cell, row) in
                self.weekRowsHaveChanged()
                cell.valueLabel.textColor = UIColor.systemPink
                cell.textLabel!.textColor = UIColor.systemPink
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
    
}
//
//let deleteAction = SwipeAction(
//        style: .destructive,
//        title: "Delete",
//        handler: { (action, row, completionHandler) in
//            globalPlansVC!.chosenPlan.weeks.remove(at: row.indexPath!.row)
//            completionHandler?(true)
//    })
//deleteAction.actionBackgroundColor = .lightGray
//deleteAction.image = UIImage(systemName: "trash")
//
//    form +++ Section()
//
//    form +++
//        MultivaluedSection(multivaluedOptions: [.Insert, .Delete]) {
//            $0.tag = "weeks"
//            $0.addButtonProvider = { section in
//                return ButtonRow(){
//                    $0.title = "Add another week"
//                    $0.tag = "addWeekProvider"
//                }.cellUpdate { cell, row in
//                    cell.textLabel?.textAlignment = .left
//                    cell.textLabel?.textColor = UIColor.lightGray
//                }
//            }
//            $0.multivaluedRowToInsertAt = { index in
//                return ButtonRow () {
//                    let newWeek = Week()
//                    globalPlansVC!.chosenPlan.weeks.append(newWeek)
//                    $0.title = "Week " + String(globalPlansVC!.chosenPlan.weeks.count)
//                    $0.value = "tap to edit"
//
//                    $0.presentationMode = .segueName(segueName: "WeekSegue", onDismiss: nil)
//                    $0.onCellSelection(self.selected)
//
//
//                    $0.trailingSwipe.actions = [deleteAction]
//                    $0.trailingSwipe.performsFirstActionWithFullSwipe = true
//                }
//            }
//            for (index, week) in globalPlansVC!.chosenPlan.weeks.enumerated() {
//                $0  <<< ButtonRow () {
//                    $0.title = "Week " + String(index)
//                    $0.value = "tap to edit"
//                    $0.presentationMode = .segueName(segueName: "WeekSegue", onDismiss: nil)
//                    $0.onCellSelection(self.selected)
//
//                    $0.trailingSwipe.actions = [deleteAction]
//                    $0.trailingSwipe.performsFirstActionWithFullSwipe = true
//                }
//            }
//    }

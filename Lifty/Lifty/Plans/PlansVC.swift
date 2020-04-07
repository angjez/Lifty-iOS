//
//  SecondViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var globalPlansVC: PlansVC?

class PlansVC: FormViewController {
    
    @IBOutlet weak var newPlanButton: UIButton!
    
    var plans = [Plan]()
    var chosenPlanRow: ButtonRowOf<String>?
    var chosenPlan = Plan(name: "")
    var chosenPlanIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalPlansVC = self as! PlansVC
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        
        initiateForm()
    
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
        
        setPinkGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
    }
    
    @IBAction func addNewPlan(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        form +++ Section()
            <<< ButtonRow () {
                $0.tag = "Add plan"
            }
        let newPlan = Plan(name: "")
        self.plans.append(newPlan)
        chosenPlan = plans.last!
        chosenPlanIndex = plans.count-1
        chosenPlanRow = (self.form.rows.last as! ButtonRowOf<String>)
        UIView.setAnimationsEnabled(true)
    }
    
    func initiateForm () {
        form.removeAll()
        UIView.setAnimationsEnabled(false)
        for (index, plan) in plans.enumerated() {
            form +++ Section()
                <<< ButtonRow () {
                    $0.title = plan.name
                    $0.tag = String(index)
                    $0.presentationMode = .segueName(segueName: "DisplayPlanSegue", onDismiss: nil)
                    $0.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                }.cellSetup { cell, _ in
                    let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
                    cell.backgroundColor = UIColor.white
                    cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                    cell.layer.borderWidth = 3.0
                    cell.contentView.layoutMargins.right = 20
            }
        }
        
        let deleteAction = SwipeAction(
            style: .normal,
            title: "Delete",
            handler: { (action, row, completionHandler) in
                UIView.setAnimationsEnabled(false)
//                deleteWorkout(workout: self.workouts[Int(row.tag!)!])
                self.plans.remove(at: Int(row.tag!)!)
                self.form.removeAll()
                self.initiateForm()
                completionHandler?(false)
        })
        deleteAction.actionBackgroundColor = .lightGray
        deleteAction.image = UIImage(systemName: "trash")
        let editAction = SwipeAction(
            style: .normal,
            title: "Edit",
            handler: { (action, row, completionHandler) in
                globalPlansVC!.chosenPlanIndex = Int(row.tag!)
                globalPlansVC!.chosenPlan = self.plans[globalPlansVC!.chosenPlanIndex!]
                globalPlansVC!.chosenPlanRow = (row as! ButtonRowOf<String>)
                self.performSegue(withIdentifier: "NewPlanSegue", sender: self.newPlanButton)
                completionHandler?(true)
        })
        editAction.actionBackgroundColor = .lightGray
        editAction.image = UIImage(systemName: "pencil")
        
        for row in form.rows {
            row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            row.trailingSwipe.actions = [deleteAction]
            row.trailingSwipe.performsFirstActionWithFullSwipe = true
            
            row.leadingSwipe.actions = [editAction]
            row.leadingSwipe.performsFirstActionWithFullSwipe = true
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        globalPlansVC!.chosenPlanIndex = Int(row.tag!)
        globalPlansVC!.chosenPlan = plans[globalPlansVC!.chosenPlanIndex!]
        globalPlansVC!.chosenPlanRow = row
    }
    
}


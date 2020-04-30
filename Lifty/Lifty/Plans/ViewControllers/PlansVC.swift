//
//  PlansVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class PlansVC: FormViewController {
    
    @IBOutlet weak var newPlanButton: UIButton!
    @IBOutlet weak var UserProfileButton: UIButton!
    
    let viewCustomisation = ViewCustomisation()
    
    var planDelegate: passPlan?
    var themeDelegate: passTheme?
    
    var plans = [Plan]()
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.initiateForm()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewCustomisation.setPinkGradients(viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewPlanVC{
            self.planDelegate = destinationVC
            self.planDelegate?.finishPassing(chosenPlan: self.chosenPlan, chosenPlanIndex: self.chosenPlanIndex)
        } else if let destinationVC = segue.destination as? DisplayPlanVC{
            self.planDelegate = destinationVC
            self.planDelegate?.finishPassing(chosenPlan: self.chosenPlan, chosenPlanIndex: self.chosenPlanIndex)
        } else if let destinationVC = segue.destination as? DisplayProfileVC{
            self.themeDelegate = destinationVC
            self.themeDelegate?.finishPassing(theme: UIColor.systemPink, gradient: CAGradientLayer.pinkGradient(on: self.view)!)
        }
    }
    
    @IBAction func addNewPlan(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        let newPlan = Plan(name: "")
        self.plans.append(newPlan)
        self.chosenPlan = plans.last!
        self.chosenPlanIndex = plans.count-1
        self.performSegue(withIdentifier: "NewPlanSegue", sender: self)
        UIView.setAnimationsEnabled(true)
    }
    
    //    MARK: Form handling.
    
    func initiateForm () {
        let user = Auth.auth().currentUser
        if let user = user {
            let planDocument = PlanDocument(uid: user.uid)
            planDocument.getPlanDocument(completion: { loadedPlans in
                self.plans = loadedPlans
                print(self.plans.count)
                
                UIView.setAnimationsEnabled(false)
                self.form.removeAll()
                for (index, plan) in self.plans.enumerated() {
                    self.form +++ Section()
                        <<< ButtonRow () {
                            $0.title = plan.name
                            $0.tag = String(index)
                            $0.onCellSelection(self.assignCellRow)
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textColor = UIColor.systemPink
                            cell.indentationLevel = 2
                            cell.indentationWidth = 10
                            cell.textLabel!.textAlignment = .left
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
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let planDocument = PlanDocument(uid: user.uid)
                            planDocument.deletePlanDocument(plan: self.plans[Int(row.tag!)!])
                        }
                        self.plans.remove(at: Int(row.tag!)!)
                        self.form.remove(at: Int(row.tag!)!)
                        self.reIndex()
                        completionHandler?(false)
                })
                deleteAction.actionBackgroundColor = .lightGray
                deleteAction.image = UIImage(systemName: "trash")
                let editAction = SwipeAction(
                    style: .normal,
                    title: "Edit",
                    handler: { (action, row, completionHandler) in
                        let newPlanVC = NewPlanVC()
                        self.planDelegate = newPlanVC
                        self.chosenPlan = self.plans[Int(row.tag!)!]
                        self.chosenPlanIndex = Int(row.tag!)
                        self.performSegue(withIdentifier: "NewPlanSegue", sender: self)
                        completionHandler?(true)
                })
                editAction.actionBackgroundColor = .lightGray
                editAction.image = UIImage(systemName: "pencil")
                
                for row in self.form.rows {
                    row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                    row.trailingSwipe.actions = [deleteAction]
                    row.trailingSwipe.performsFirstActionWithFullSwipe = true
                    row.leadingSwipe.actions = [editAction]
                    row.leadingSwipe.performsFirstActionWithFullSwipe = true
                }
                UIView.setAnimationsEnabled(true)
                self.viewDidAppear(false)
            })
        }
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.chosenPlanIndex = Int(row.tag!)
        self.chosenPlan = plans[self.chosenPlanIndex!]
        self.performSegue(withIdentifier: "DisplayPlanSegue", sender: self)
    }
    
    func reIndex() {
        for (index, row) in self.form.rows.enumerated() {
            row.tag = String(index)
        }
    }

    
}


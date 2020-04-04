//
//  FirstViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

var chosenWorkoutCell: ButtonCellOf<String>?
var chosenWorkoutRow: ButtonRowOf<String>?
var workoutIndex: Int?
var chosenWorkout = Workout()
var globalSavedWorkoutsVC: SavedWorkoutsVC?

class SavedWorkoutsVC: FormViewController {
    
    @IBOutlet weak var NewWorkoutButton: UIBarButtonItem!
    
    private let greenView = UIView()
    
    var workouts = [Workout]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        guard let tabBarController = self.tabBarController
        else {
            print("Error initializing tab bar controller!")
            return
        }
        guard let navigationController = self.navigationController
        else {
            print("Error initializing tab bar controller!")
            return
        }

        setGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
        
        globalSavedWorkoutsVC = self as! SavedWorkoutsVC
        
        self.tableView.rowHeight = 70

        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        
//        deleteAll()
        loadWorkouts()
        initiateForm()
    }
    
    
    func initiateForm () {
        let deleteAction = SwipeAction(
            style: .destructive,
            title: "Delete",
            handler: { (action, row, completionHandler) in
                deleteWorkout(workout: self.workouts[row.indexPath!.row])
                self.workouts.remove(at: row.indexPath!.row)
                completionHandler?(true)
            })
        let editAction = SwipeAction(
            style: .normal,
            title: "Edit",
            handler: { (action, row, completionHandler) in
                workoutIndex = row.indexPath!.row
                chosenWorkout = self.workouts[row.indexPath!.row]
                chosenWorkoutRow = (row as! ButtonRowOf<String>)
                self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                 completionHandler?(true)
                completionHandler?(true)
            })
        editAction.actionBackgroundColor = .orange
        
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete]) {
                                $0.tag = "workouts"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add workout"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                            cell.textLabel?.textColor = #colorLiteral(red: 0.6745098039, green: 0.168627451, blue: 0.1490196078, alpha: 1)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return ButtonRow () {
                                        $0.title = "Workout"
                                        $0.value = "tap to edit"
                                        $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                        $0.onCellSelection(self.assignCellRow)
                                        let newWorkout = Workout()
                                        self.workouts.append(newWorkout)
                                        saveWorkout(workout: newWorkout)

                                        $0.cell.backgroundColor = UIColor.clear
                                        $0.cell.layer.borderColor = UIColor.white.cgColor
                                        $0.cell.layer.borderWidth = 3.0
                                        $0.cell.contentView.layoutMargins.right = 20

                                        workoutIndex = index
                                        chosenWorkoutCell = $0.cell
                                        chosenWorkoutRow = $0
                                        chosenWorkout = newWorkout
                                        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                                    }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor.white
                                    cell.indentationLevel = 2
                                    cell.indentationWidth = 10
                                    }
                                }
                if (workouts.isEmpty) {
                                $0  <<< ButtonRow () {
                                    $0.title = "Workout"
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                    $0.onCellSelection(self.assignCellRow)
                                    let newWorkout = Workout()
                                    self.workouts.append(newWorkout)
                                    saveWorkout(workout: newWorkout)

                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor.white
                                    cell.indentationLevel = 2
                                }.cellSetup { cell, _ in
                                    cell.backgroundColor = UIColor.clear
                                    cell.layer.borderColor = UIColor.white.cgColor
                                    cell.layer.borderWidth = 3.0
                                    cell.contentView.layoutMargins.right = 20
                                }
                }
                for workout in workouts {
                        $0  <<< ButtonRow () {
                                $0.title = workout.name
                                $0.value = "tap to edit"
                                $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                $0.onCellSelection(self.assignCellRow)
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textColor = UIColor.white
                            cell.indentationLevel = 2
                            cell.indentationWidth = 10
                        }.cellSetup { cell, _ in
                            cell.backgroundColor = UIColor.clear
                            cell.layer.borderColor = UIColor.white.cgColor
                            cell.layer.borderWidth = 3.0
                            cell.contentView.layoutMargins.right = 20
                        }
                }
            }
        
        for row in form.rows {
            row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            row.trailingSwipe.actions = [deleteAction]
            row.trailingSwipe.performsFirstActionWithFullSwipe = true

            row.leadingSwipe.actions = [editAction]
            row.leadingSwipe.performsFirstActionWithFullSwipe = true
        }

    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        chosenWorkout = workouts[row.indexPath!.row]
        workoutIndex = row.indexPath!.row
        chosenWorkoutCell = cell
        chosenWorkoutRow = row
    }
    
    func changeWorkoutData (modifiedWorkout: Workout) {
        
        for (index, workout) in workouts.enumerated()  {
            if index == workoutIndex {
                deleteWorkout(workout: workout)
                workout.assign(workoutToAssign: modifiedWorkout)
                saveWorkout(workout: workout)
                chosenWorkoutRow!.title = workout.name
                chosenWorkoutRow!.updateCell()
                break
            }
        }
    }

}

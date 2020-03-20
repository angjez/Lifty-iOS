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
    
    var workouts = [Workout]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        globalSavedWorkoutsVC = self as! SavedWorkoutsVC
        
        self.view.backgroundColor = UIColor.white
        self.initiateForm()
    }
    
    func initiateForm () {
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete]) {
                                $0.tag = "workouts"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add workout"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
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
                                        
                                        
                                        let deleteAction = SwipeAction(
                                            style: .destructive,
                                            title: "Delete",
                                            handler: { (action, row, completionHandler) in
                                                self.workouts.remove(at: index)
                                                completionHandler?(true)
                                            })

                                        $0.trailingSwipe.actions = [deleteAction]
                                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                        let infoAction = SwipeAction(
                                            style: .normal,
                                            title: "Edit",
                                            handler: { (action, row, completionHandler) in
                                                self.editWorkout()
                                                completionHandler?(true)
                                            })
                                        infoAction.actionBackgroundColor = .orange

                                        $0.leadingSwipe.actions = [infoAction]
                                        $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                        

                                        workoutIndex = index
                                        chosenWorkoutCell = $0.cell
                                        chosenWorkoutRow = $0
                                        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                                    }
                                }
                                $0  <<< ButtonRow () {
                                    $0.title = "Workout"
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                    $0.onCellSelection(self.assignCellRow)
                                    let newWorkout = Workout()
                                    self.workouts.append(newWorkout)
                                    
                                    let deleteAction = SwipeAction(
                                         style: .destructive,
                                         title: "Delete",
                                         handler: { (action, row, completionHandler) in
                                            self.workouts.remove(at: 0)
                                             completionHandler?(true)
                                         })

                                     $0.trailingSwipe.actions = [deleteAction]
                                     $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                     let infoAction = SwipeAction(
                                         style: .normal,
                                         title: "Edit",
                                         handler: { (action, row, completionHandler) in
                                            self.editWorkout ()
                                             completionHandler?(true)
                                         })
                                     infoAction.actionBackgroundColor = .orange

                                     $0.leadingSwipe.actions = [infoAction]
                                     $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                    
                                }
            }
        
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        chosenWorkout = workouts[row.indexPath!.row]
        workoutIndex = row.indexPath!.row
        chosenWorkoutCell = cell
        chosenWorkoutRow = row
    }
    
    func editWorkout () {
        
    }
    
    func changeWorkoutData (modifiedWorkout: Workout) {
        
        for (index, workout) in workouts.enumerated()  {
            if index == workoutIndex {
                workout.assign(workoutToAssign: modifiedWorkout)
                chosenWorkoutRow!.title = workout.name
                chosenWorkoutRow!.updateCell()
                break
            }
        }
    }
    
}


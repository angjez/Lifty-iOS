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

class SavedWorkoutsVC: FormViewController {
    
    @IBOutlet weak var NewWorkoutButton: UIBarButtonItem!
    
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                                        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
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
                                                self.deleteWorkout()
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
                                            self.deleteWorkout()
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
//        workoutIndex = row.indexPath!.row + 1
        chosenWorkoutCell = cell
        chosenWorkoutRow = row
    }
    
    func deleteWorkout () {
        
    }
    
    func editWorkout () {
        
    }
    
    func changeWorkoutData (workout: Workout) {
    }
    
}

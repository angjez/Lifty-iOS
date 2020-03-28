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
        
        guard
            let navigationController = navigationController,
            let flareGradientImageNavBar = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
            }

        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImageNavBar)
        guard
            let tabBarController = tabBarController,
            let flareGradientImageTabBar = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
            }
        tabBarController.tabBar.barTintColor = UIColor(patternImage: flareGradientImageTabBar)
        
        globalSavedWorkoutsVC = self as! SavedWorkoutsVC
        
//        deleteAll()
        loadWorkouts()
        
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
                                        saveWorkout(workout: newWorkout)
                                        
                                        
                                        let deleteAction = SwipeAction(
                                            style: .destructive,
                                            title: "Delete",
                                            handler: { (action, row, completionHandler) in
                                                deleteWorkout(workout: self.workouts[index])
                                                self.workouts.remove(at: index)
                                                completionHandler?(true)
                                            })

                                        $0.trailingSwipe.actions = [deleteAction]
                                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                        let infoAction = SwipeAction(
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
                                        infoAction.actionBackgroundColor = .orange

                                        $0.leadingSwipe.actions = [infoAction]
                                        $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                        

                                        workoutIndex = index
                                        chosenWorkoutCell = $0.cell
                                        chosenWorkoutRow = $0
                                        chosenWorkout = newWorkout
                                        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                                    }
                                }
                if (workouts.count == 0) {
                                $0  <<< ButtonRow () {
                                    $0.title = "Workout"
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                    $0.onCellSelection(self.assignCellRow)
                                    let newWorkout = Workout()
                                    self.workouts.append(newWorkout)
                                    saveWorkout(workout: newWorkout)
                                    
                                    let deleteAction = SwipeAction(
                                         style: .destructive,
                                         title: "Delete",
                                         handler: { (action, row, completionHandler) in
                                            deleteWorkout(workout: self.workouts[0])
                                            self.workouts.remove(at: 0)
                                            completionHandler?(true)
                                         })

                                     $0.trailingSwipe.actions = [deleteAction]
                                     $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                     let infoAction = SwipeAction(
                                         style: .normal,
                                         title: "Edit",
                                         handler: { (action, row, completionHandler) in
                                            chosenWorkout = self.workouts[row.indexPath!.row]
                                            workoutIndex = row.indexPath!.row
                                            chosenWorkoutRow = (row as! ButtonRowOf<String>)
                                            self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                                             completionHandler?(true)
                                             completionHandler?(true)
                                         })
                                     infoAction.actionBackgroundColor = .orange

                                     $0.leadingSwipe.actions = [infoAction]
                                     $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                    
                                }
                }
                for (index, workout) in workouts.enumerated() {
                        $0  <<< ButtonRow () {
                                $0.title = workout.name
                                $0.value = "tap to edit"
                                $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                                $0.onCellSelection(self.assignCellRow)
                                
                                let deleteAction = SwipeAction(
                                     style: .destructive,
                                     title: "Delete",
                                     handler: { (action, row, completionHandler) in
                                        deleteWorkout(workout: self.workouts[row.indexPath!.row])
                                        self.workouts.remove(at: index)
                                        completionHandler?(true)
                                     })

                                 $0.trailingSwipe.actions = [deleteAction]
                                 $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                 let infoAction = SwipeAction(
                                     style: .normal,
                                     title: "Edit",
                                     handler: { (action, row, completionHandler) in
                                        chosenWorkout = self.workouts[row.indexPath!.row]
                                        workoutIndex = row.indexPath!.row
                                        chosenWorkoutRow = (row as! ButtonRowOf<String>)
                                        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                                         completionHandler?(true)
                                     })
                                 infoAction.actionBackgroundColor = .orange

                                 $0.leadingSwipe.actions = [infoAction]
                                 $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                    }
                }
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


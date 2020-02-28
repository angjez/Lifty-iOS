//
//  FirstViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class SavedWorkoutsVC: FormViewController {
    
    var workouts = [Workout]()
    var WorkoutRowTitles: [String] =  []
    
    @IBOutlet weak var NewWorkoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initiateForm()
    }
    
    public func addWorkout (workout: Workout) {
        self.workouts.append(workout)
        print(workouts)
        self.loadView()
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
                                        self.WorkoutRowTitles.append("Workout \(index+1)")
                                        $0.title = self.WorkoutRowTitles[index]
                                        $0.value = "tap to edit"
                                        $0.presentationMode = .segueName(segueName: "NewWorkoutSegue", onDismiss: nil)
//                                        $0.onCellSelection(self.buttonTapped)
//                                        let newExercise = Exercise(exerciseName: rowTitles[index], exerciseIndex: index+1)
//                                        self.workout.addExercise(exercise: newExercise)
                                        
                                        
                                        let deleteAction = SwipeAction(
                                            style: .destructive,
                                            title: "Delete",
                                            handler: { (action, row, completionHandler) in
                                                //add your code here.
                                                //make sure you call the completionHandler once done.
                                                completionHandler?(true)
                                            })

                                        $0.trailingSwipe.actions = [deleteAction]
                                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                        let infoAction = SwipeAction(
                                            style: .normal,
                                            title: "Favourite",
                                            handler: { (action, row, completionHandler) in
                                                //add your code here.
                                                //make sure you call the completionHandler once done.
                                                completionHandler?(true)
                                            })
                                        infoAction.actionBackgroundColor = .orange

                                        $0.leadingSwipe.actions = [infoAction]
                                        $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                    }
                                }
                                $0  <<< ButtonRow () {
                                    self.WorkoutRowTitles.append("Workout 1")
                                    $0.title = self.WorkoutRowTitles[0]
                                    $0.value = "tap to edit"
                                    $0.presentationMode = .segueName(segueName: "NewWorkoutSegue", onDismiss: nil)
//                                    $0.onCellSelection(self.buttonTapped)
//                                    let newExercise = Exercise(exerciseName: rowTitles[0], exerciseIndex: 1)
//                                    self.workout.addExercise(exercise: newExercise)
                                    
                                    
                                    
                                    let deleteAction = SwipeAction(
                                         style: .destructive,
                                         title: "Delete",
                                         handler: { (action, row, completionHandler) in
                                             //add your code here.
                                             //make sure you call the completionHandler once done.
                                             completionHandler?(true)
                                         })

                                     $0.trailingSwipe.actions = [deleteAction]
                                     $0.trailingSwipe.performsFirstActionWithFullSwipe = true

                                     let infoAction = SwipeAction(
                                         style: .normal,
                                         title: "Favourite",
                                         handler: { (action, row, completionHandler) in
                                             //add your code here.
                                             //make sure you call the completionHandler once done.
                                             completionHandler?(true)
                                         })
                                     infoAction.actionBackgroundColor = .orange

                                     $0.leadingSwipe.actions = [infoAction]
                                     $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                                    
                                }
            }
        
    }


    
//    
//    func workoutPressedActionSheet(controller: UIViewController) {
//        let alert = UIAlertController()
//        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
////            proceed to editing
//        }))
//
//        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (_) in
////            proceed to selecting
//        }))
//
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
////            proceed to deleting
//        }))
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
////            dismiss
//        }))
//
//        self.present(alert, animated: true)
//    }
    
}


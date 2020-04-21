//
//  ChooseWorkoutsVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class ChooseWorkoutsVC: FormViewController, passPlan, passWeek, passDay {
    
    var workoutDelegate: passWorkoutFromPlans?
    var chosenWorkout = Workout(name: "")
    var workouts = [Workout]()
    
    let viewCustomisation = ViewCustomisation()
    
    let workoutsSelectable = SelectableSection<ImageCheckRow<String>>("Swipe right for workout preview", selectionType: .multipleSelection)
    
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    var chosenWeek = Week()
    var chosenWeekIndex: Int?
    var chosenDay = Day()
    var chosenDayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        self.createSelectableWorkoutForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewCustomisation.setPinkGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenDay: Day, chosenDayIndex: Int?) {
        
        self.chosenDay = chosenDay
        self.chosenDayIndex = chosenDayIndex
    }
    
    func finishPassing(chosenPlan: Plan, chosenPlanIndex: Int?) {
        self.chosenPlan = chosenPlan
        self.chosenPlanIndex = chosenPlanIndex
    }
    
    func finishPassing(chosenWeek: Week, chosenWeekIndex: Int?) {
        self.chosenWeek = chosenWeek
        self.chosenWeekIndex = chosenWeekIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DisplayWorkoutVC{
            self.workoutDelegate = destinationVC
            self.workoutDelegate?.finishPassingFromPlans(chosenWorkout: self.chosenWorkout)
        }
    }
    
    //    MARK: Form handling.
    
    func createSelectableWorkoutForm () {
        let user = Auth.auth().currentUser
        if let user = user {
            let workoutDocument = WorkoutDocument(uid: user.uid)
            workoutDocument.getWorkoutDocument(completion: { loadedWorkouts in
                self.workouts = loadedWorkouts
                print(loadedWorkouts.count)
                let infoAction = SwipeAction(
                    style: .normal,
                    title: "Info",
                    handler: { (action, row, completionHandler) in
                        for (index, workout) in self.workouts.enumerated()  {
                            if workout.name + String(index) == row.tag {
                                self.chosenWorkout = self.workouts[index]
                                self.performSegue(withIdentifier: "DisplayWorkoutSegueFromChecklist", sender: self)
                                completionHandler?(true)
                            }
                        }
                })
                infoAction.actionBackgroundColor = .lightGray
                infoAction.image = UIImage(systemName: "info")
                
                self.form +++ self.workoutsSelectable
                for (index, workout) in self.workouts.enumerated()  {
                    self.form.last! <<< ImageCheckRow<String>(workout.name + String(index)){ lrow in
                        lrow.title = workout.name
                        lrow.selectableValue = workout.name
                        lrow.value = nil
                        lrow.leadingSwipe.actions = [infoAction]
                        lrow.leadingSwipe.performsFirstActionWithFullSwipe = true
                        for alreadyChosenWorkout in self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].workouts {
                            if workout.name == alreadyChosenWorkout.name {
                                lrow.value = workout.name
                                lrow.didSelect()
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                self.viewDidAppear(false)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].workouts.removeAll()
        for workout in self.workouts {
            for selectableWorkoutRow in workoutsSelectable.selectedRows() {
                if selectableWorkoutRow.title! == workout.name {
                    self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].workouts.append(workout)
                }
            }
        }
    }
    
}

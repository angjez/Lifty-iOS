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
    
    var workoutDelegate: passWorkoutAndIndex?
    var chosenWorkout = Workout(name: "")
    var chosenWorkoutIndex: Int?
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
        
        let user = Auth.auth().currentUser
        if let user = user {
            let workoutDocument = WorkoutDocument(uid: user.uid)
            workoutDocument.getWorkoutDocument(completion: { loadedWorkouts in
                self.workouts = loadedWorkouts
            })
        }
        
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
        if let destinationVC = segue.destination as? WorkoutsVC{
            self.workoutDelegate = destinationVC
            self.workoutDelegate?.finishPassingWithIndex(chosenWorkout: self.chosenWorkout, chosenWorkoutIndex: self.chosenWorkoutIndex)
        }
    }
    
    //    MARK: Form handling.

    func createSelectableWorkoutForm () {
        let infoAction = SwipeAction(
            style: .normal,
            title: "Info",
            handler: { (action, row, completionHandler) in
                self.chosenWorkoutIndex = row.indexPath!.row
                self.chosenWorkout = self.workouts[self.chosenWorkoutIndex!]
                self.performSegue(withIdentifier: "DisplayWorkoutSegueFromChecklist", sender: self)
                completionHandler?(true)
        })
        infoAction.actionBackgroundColor = .lightGray
        infoAction.image = UIImage(systemName: "info")

        form +++ workoutsSelectable
        for (index, workout) in self.workouts.enumerated()  {
            form.last! <<< ImageCheckRow<String>(workout.name + String(index)){ lrow in
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

//
//  ChooseWorkoutsVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class ChooseWorkoutsVC: FormViewController {
    
    let workoutsSelectable = SelectableSection<ImageCheckRow<String>>("Swipe right for workout preview", selectionType: .multipleSelection)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        createSelectableWorkoutForm()
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
    
    func createSelectableWorkoutForm () {
        let infoAction = SwipeAction(
            style: .normal,
            title: "Info",
            handler: { (action, row, completionHandler) in
                globalSavedWorkoutsVC!.chosenWorkoutIndex = row.indexPath!.row
                globalSavedWorkoutsVC!.chosenWorkout = globalSavedWorkoutsVC!.workouts[globalSavedWorkoutsVC!.chosenWorkoutIndex!]
                self.performSegue(withIdentifier: "DisplayWorkoutSegueFromChecklist", sender: self)
                completionHandler?(true)
        })
        infoAction.actionBackgroundColor = .lightGray
        infoAction.image = UIImage(systemName: "info")
        
        form +++ workoutsSelectable
        for (index, workout) in globalSavedWorkoutsVC!.workouts.enumerated()  {
            form.last! <<< ImageCheckRow<String>(workout.name + String(index)){ lrow in
                lrow.title = workout.name
                lrow.selectableValue = workout.name
                lrow.value = nil
                lrow.leadingSwipe.actions = [infoAction]
                lrow.leadingSwipe.performsFirstActionWithFullSwipe = true
                for alreadyChosenWorkout in globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days[(globalWeekVC?.chosenDayIndex)!].workouts {
                    if workout.name == alreadyChosenWorkout.name {
                        lrow.value = workout.name
                        lrow.didSelect()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days[(globalWeekVC?.chosenDayIndex)!].workouts.removeAll()
        for workout in globalSavedWorkoutsVC!.workouts {
            for selectableWorkoutRow in workoutsSelectable.selectedRows() {
                if selectableWorkoutRow.title! == workout.name {
                    globalPlansVC!.chosenPlan.weeks[globalNewPlanVC!.chosenWeekIndex!].days[(globalWeekVC?.chosenDayIndex)!].workouts.append(workout)
                }
            }
        }
    }
    
}

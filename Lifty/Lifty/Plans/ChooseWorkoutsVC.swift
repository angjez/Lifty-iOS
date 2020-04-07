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
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.tableView.separatorColor = UIColor.systemPink
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        createSelectableWorkoutForm()
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
        for workout in globalSavedWorkoutsVC!.workouts  {
            form.last! <<< ImageCheckRow<String>(workout.name){ lrow in
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

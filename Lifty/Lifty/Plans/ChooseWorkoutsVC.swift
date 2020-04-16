//
//  ChooseWorkoutsVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class ChooseWorkoutsVC: FormViewController, passPlan, passWeek, passDay {
    
    let workoutsSelectable = SelectableSection<ImageCheckRow<String>>("Swipe right for workout preview", selectionType: .multipleSelection)
    
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    var chosenWeek = Week()
    var chosenWeekIndex: Int?
    var chosenDay = Day()
    var chosenDayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        createSelectableWorkoutForm()
    }
    
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
                globalWorkoutsVC!.chosenWorkoutIndex = row.indexPath!.row
                globalWorkoutsVC!.chosenWorkout = globalWorkoutsVC!.workouts[globalWorkoutsVC!.chosenWorkoutIndex!]
                self.performSegue(withIdentifier: "DisplayWorkoutSegueFromChecklist", sender: self)
                completionHandler?(true)
        })
        infoAction.actionBackgroundColor = .lightGray
        infoAction.image = UIImage(systemName: "info")
        
        form +++ workoutsSelectable
        for (index, workout) in globalWorkoutsVC!.workouts.enumerated()  {
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
        for workout in globalWorkoutsVC!.workouts {
            for selectableWorkoutRow in workoutsSelectable.selectedRows() {
                if selectableWorkoutRow.title! == workout.name {
                    self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].workouts.append(workout)
                }
            }
        }
    }
    
}

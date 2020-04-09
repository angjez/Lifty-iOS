//
//  DisplayPlanVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class DisplayPlanVC: FormViewController {
    
    var currentWeekIndex = 0
    
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
        
        //        add gesture recognizers
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        initiatePlanLabelForm()
        initiateWeekLabelForm()
        initiateDayRows ()
    }
    
    @objc
    func leftSwipe(){
        //        next day
        print("left")
        if(currentWeekIndex < globalPlansVC!.chosenPlan.weeks.count - 1) {
            currentWeekIndex += 1
            self.form.removeAll()
            initiatePlanLabelForm()
            initiateWeekLabelForm()
            initiateDayRows()
        }
    }
    
    @objc
    func rightSwipe(){
        print("right")
        //        prev day
        if(currentWeekIndex != 0) {
            currentWeekIndex += -1
            self.form.removeAll()
            initiatePlanLabelForm()
            initiateWeekLabelForm()
            initiateDayRows()
        }
    }
    
    func initiatePlanLabelForm () {
        UIView.setAnimationsEnabled(false)
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        form +++ Section()
            <<< LabelRow () {
                $0.title = globalPlansVC!.chosenPlan.name
            }.cellUpdate { cell, row in
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 50)
                cell.textLabel?.textColor = UIColor.systemPink
                cell.indentationLevel = 2
                cell.indentationWidth = 10
                cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                cell.layer.borderWidth = 3.0
                cell.contentView.layoutMargins.right = 20
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func initiateWeekLabelForm () {
        UIView.setAnimationsEnabled(false)
        form +++ LabelRow () {
            $0.title = "Week " + String(currentWeekIndex + 1)
        }.cellUpdate { cell, row in
            cell.height = {30}
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.indentationLevel = 2
            cell.indentationWidth = 10
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 3.0
            cell.contentView.layoutMargins.right = 20
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func initiateDayRows () {
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        UIView.setAnimationsEnabled(false)
        for (dayIndex, day) in globalPlansVC!.chosenPlan.weeks[currentWeekIndex].days.enumerated() {
            form +++ Section()
                <<< LabelRow () {
                    $0.title = "Day " + String(dayIndex + 1)
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                    cell.textLabel?.textColor = UIColor.systemPink
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                    cell.backgroundColor = UIColor.white
                    cell.layer.borderColor = UIColor(patternImage: pinkGradientImage!).cgColor
                    cell.layer.borderWidth = 3.0
                    cell.contentView.layoutMargins.right = 20
            }
            for (workoutIndex, workout) in globalPlansVC!.chosenPlan.weeks[currentWeekIndex].days[dayIndex].workouts.enumerated() {
                form +++ Section()
                    <<< ButtonRow () {
                        $0.title = workout.name
                        $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegueFromPlanDisplay", onDismiss: nil)
                        $0.onCellSelection(self.assignCellRow)
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textColor = UIColor.systemPink
                        cell.indentationLevel = 2
                        cell.indentationWidth = 10
                }
            }
        }
        for row in form.rows {
            row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        for (index, workout) in globalSavedWorkoutsVC!.workouts.enumerated() {
            if workout.name == row.title {
                globalSavedWorkoutsVC!.chosenWorkoutIndex = index
                globalSavedWorkoutsVC!.chosenWorkout = workout
            }
        }
    }
    
}

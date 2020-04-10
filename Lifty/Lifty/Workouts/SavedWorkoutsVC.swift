//
//  FirstViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka

var globalSavedWorkoutsVC: SavedWorkoutsVC?

class SavedWorkoutsVC: FormViewController {
    
    @IBOutlet weak var NewWorkoutButton: UIButton!
    
    private let greenView = UIView()
    
    var workouts = [Workout]()
    var chosenWorkoutRow: ButtonRowOf<String>?
    var chosenWorkout = Workout(name: "")
    var chosenWorkoutIndex: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        globalSavedWorkoutsVC = self as! SavedWorkoutsVC
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor.white
        self.tableView?.frame = CGRect(x: 20, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-40, height: (self.tableView?.frame.size.height)!)
        
        loadWorkouts()
        initiateForm()
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
        
        setBlueGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
    }
    
    @IBAction func addNewWorkout(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        form +++ Section()
            <<< ButtonRow () {
                $0.title = "New workout"
                $0.tag = "Add workout"
            }
        let newWorkout = Workout(name: "")
        self.workouts.append(newWorkout)
        saveWorkout(workout: newWorkout)
        chosenWorkout = workouts.last!
        chosenWorkoutIndex = workouts.count-1
        chosenWorkoutRow = (self.form.rows.last as! ButtonRowOf<String>)
        UIView.setAnimationsEnabled(true)
        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
    }
    
    
    func initiateForm () {
        UIView.setAnimationsEnabled(false)
        for (index, workout) in workouts.enumerated() {
            form +++ Section()
                <<< ButtonRow () {
                    $0.title = workout.name
                    $0.tag = String(index)
                    $0.value = "tap to edit"
                    $0.presentationMode = .segueName(segueName: "DisplayWorkoutSegue", onDismiss: nil)
                    $0.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemIndigo
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                }.cellSetup { cell, _ in
                    let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                    cell.backgroundColor = UIColor.white
                    cell.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
                    cell.layer.borderWidth = 3.0
                    cell.contentView.layoutMargins.right = 20
            }
        }
        
        let deleteAction = SwipeAction(
            style: .normal,
            title: "Delete",
            handler: { (action, row, completionHandler) in
                UIView.setAnimationsEnabled(false)
                deleteWorkout(workout: self.workouts[Int(row.tag!)!])
                self.workouts.remove(at: Int(row.tag!)!)
                self.form.removeAll()
                self.initiateForm()
                completionHandler?(true)
        })
        deleteAction.actionBackgroundColor = .lightGray
        deleteAction.image = UIImage(systemName: "trash")
        let editAction = SwipeAction(
            style: .normal,
            title: "Edit",
            handler: { (action, row, completionHandler) in
                globalSavedWorkoutsVC!.chosenWorkoutIndex = Int(row.tag!)
                globalSavedWorkoutsVC!.chosenWorkout = self.workouts[globalSavedWorkoutsVC!.chosenWorkoutIndex!]
                globalSavedWorkoutsVC!.chosenWorkoutRow = (row as! ButtonRowOf<String>)
                self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
                completionHandler?(true)
        })
        editAction.actionBackgroundColor = .lightGray
        editAction.image = UIImage(systemName: "pencil")
        
        for row in form.rows {
            row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            row.trailingSwipe.actions = [deleteAction]
            row.trailingSwipe.performsFirstActionWithFullSwipe = true
            
            row.leadingSwipe.actions = [editAction]
            row.leadingSwipe.performsFirstActionWithFullSwipe = true
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        globalSavedWorkoutsVC!.chosenWorkoutIndex = Int(row.tag!)
        globalSavedWorkoutsVC!.chosenWorkout = workouts[globalSavedWorkoutsVC!.chosenWorkoutIndex!]
        globalSavedWorkoutsVC!.chosenWorkoutRow = row
    }
    
    func changeWorkoutData (modifiedWorkout: Workout) {
        form.removeAll()
        for (index, workout) in self.workouts.enumerated()  {
            if workout.name == chosenWorkout.name && index == chosenWorkoutIndex {
                deleteWorkout(workout: workout)
                workout.assign(workoutToAssign: modifiedWorkout)
                saveWorkout(workout: workout)
                chosenWorkoutRow!.title = workout.name
                chosenWorkoutRow!.updateCell()
                break
            }
        }
        initiateForm()
    }
    
}

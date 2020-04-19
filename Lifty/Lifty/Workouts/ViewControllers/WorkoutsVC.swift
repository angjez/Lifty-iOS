//
//  WorkoutsVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka
import Firebase

class WorkoutsVC: FormViewController, passWorkoutAndIndex {
    
    @IBOutlet weak var NewWorkoutButton: UIButton!
    @IBOutlet weak var UserProfileButton: UIButton!
    
    let viewCustomisation = ViewCustomisation()
    
    var workoutDelegate: passWorkout?
    var themeDelegate: passTheme?
    
    private let greenView = UIView()
    
    var workouts = [Workout]()
    var chosenWorkout = Workout(name: "")
    var chosenWorkoutIndex: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        if(user == nil) {
            print("not logged")
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "LoginScreenSegue", sender: self)
            UIView.setAnimationsEnabled(true)
        } else {
            let workoutDocument = WorkoutDocument(uid: user!.uid)
            workoutDocument.getWorkoutDocument(completion: { loadedWorkouts in
                self.workouts = loadedWorkouts
                print(self.workouts.count)
                UIView.setAnimationsEnabled(false)
                self.initiateForm()
                UIView.setAnimationsEnabled(true)
            })
            
        }
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.viewCustomisation.setBlueGradients(viewController: self)
        
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassingWithIndex(chosenWorkout: Workout, chosenWorkoutIndex: Int?) {
        self.chosenWorkout = chosenWorkout
        self.chosenWorkoutIndex = chosenWorkoutIndex
        print("finished passing")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewWorkoutVC{
            self.workoutDelegate = destinationVC
            self.workoutDelegate?.finishPassing(chosenWorkout: chosenWorkout)
        } else if let destinationVC = segue.destination as? DisplayWorkoutVC{
            self.workoutDelegate = destinationVC
            self.workoutDelegate?.finishPassing(chosenWorkout: chosenWorkout)
        } else if let destinationVC = segue.destination as? DisplayProfileVC{
            self.themeDelegate = destinationVC
            self.themeDelegate?.finishPassing(theme: UIColor.systemIndigo, gradient: CAGradientLayer.blueGradient(on: self.view)!)
        }
    }
    
    //    MARK: Form handling.
    
    @IBAction func addNewWorkout(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        form +++ Section()
            <<< ButtonRow () {
                $0.title = "New workout"
                $0.tag = "Add workout"
        }
        let newWorkout = Workout(name: "")
        self.workouts.append(newWorkout)
        chosenWorkout = workouts.last!
        chosenWorkoutIndex = workouts.count-1
        UIView.setAnimationsEnabled(true)
        self.performSegue(withIdentifier: "NewWorkoutSegue", sender: self.NewWorkoutButton)
    }
    
    func initiateForm () {
        UIView.setAnimationsEnabled(false)
        form.removeAll()
        for (index, workout) in workouts.enumerated() {
            form +++ Section()
                <<< ButtonRow () {
                    $0.title = workout.name
                    $0.tag = String(index)
                    $0.value = "tap to edit"
                    $0.onCellSelection(self.assignCellRow)
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.systemIndigo
                    cell.indentationLevel = 2
                    cell.indentationWidth = 10
                    cell.textLabel!.textAlignment = .left
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
                let user = Auth.auth().currentUser
                if let user = user {
                    let workoutDocument = WorkoutDocument(uid: user.uid)
                    workoutDocument.deleteWorkoutDocument (workout: self.workouts[Int(row.tag!)!])
                }
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
                self.chosenWorkoutIndex = Int(row.tag!)
                self.chosenWorkout = self.workouts[self.chosenWorkoutIndex!]
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
        self.viewDidAppear(false)
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.chosenWorkoutIndex = Int(row.tag!)
        self.chosenWorkout = workouts[self.chosenWorkoutIndex!]
        self.performSegue(withIdentifier: "DisplayWorkoutSegue", sender: self.NewWorkoutButton)
    }
    
}

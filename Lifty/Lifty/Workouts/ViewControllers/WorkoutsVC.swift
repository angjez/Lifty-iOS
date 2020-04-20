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
    
    // search controller's properties
    let searchController = UISearchController(searchResultsController: nil)
    var originalOptions = [ButtonRow]()
    var currentOptions = [ButtonRow]()
    var scopeTitles = ["All", "FOR TIME", "EMOM", "AMRAP", "TABATA"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchControllerSetup()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        let user = Auth.auth().currentUser
        if(user == nil) {
            print("not logged")
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "LoginScreenSegue", sender: self)
            UIView.setAnimationsEnabled(true)
        }
        UIView.setAnimationsEnabled(false)
        self.initiateForm()
        self.originalOptions = self.currentOptions
        UIView.setAnimationsEnabled(true)
        
        guard let navigationController = navigationController else { return }
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.viewCustomisation.setBlueGradients(viewController: self)
        
    }
    
    func searchControllerSetup () {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = scopeTitles
        for subView in searchController.searchBar.subviews {
            if let scopeBar = subView as? UISegmentedControl {
                scopeBar.backgroundColor = UIColor.white
                scopeBar.tintColor = UIColor.systemIndigo
            }
        }
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemIndigo], for: .selected)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        if let topView = searchController.searchBar.subviews.first {
            for subView in topView.subviews {
                if let cancelButton = subView as? UIButton {
                    cancelButton.tintColor = UIColor.white
                    cancelButton.isEnabled = true
                }
            }
        }
        searchController.searchBar.delegate = self
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.tintColor = UIColor.systemIndigo
            textfield.textColor = UIColor.systemIndigo
            textfield.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo])
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
            }
        }
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
        form +++ ButtonRow () {
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
        let user = Auth.auth().currentUser
        if let user = user {
            let workoutDocument = WorkoutDocument(uid: user.uid)
            workoutDocument.getWorkoutDocument(completion: { loadedWorkouts in
                self.workouts = loadedWorkouts
                print(self.workouts.count)
                UIView.setAnimationsEnabled(false)
                self.form.removeAll()
                for (index, workout) in self.workouts.enumerated() {
                    self.form +++
                         ButtonRow () {
                            self.originalOptions.append($0)
                            $0.title = workout.name
                            $0.value = workout.type
                            $0.tag = String(index)
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
                        let user = Auth.auth().currentUser
                        if let user = user {
                            let workoutDocument = WorkoutDocument(uid: user.uid)
                            workoutDocument.deleteWorkoutDocument (workout: self.workouts[Int(row.tag!)!])
                        }
                        self.workouts.remove(at: Int(row.tag!)!)
                        self.form.remove(at: Int(row.tag!)!)
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
                
                for row in self.form.rows {
                    row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                    row.trailingSwipe.actions = [deleteAction]
                    row.trailingSwipe.performsFirstActionWithFullSwipe = true
                    row.leadingSwipe.actions = [editAction]
                    row.leadingSwipe.performsFirstActionWithFullSwipe = true
                }
                UIView.setAnimationsEnabled(true)
                self.tableView.reloadData()
                self.viewDidAppear(false)
            })
        }
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.chosenWorkoutIndex = Int(row.tag!)
        self.chosenWorkout = workouts[self.chosenWorkoutIndex!]
        self.performSegue(withIdentifier: "DisplayWorkoutSegue", sender: self.NewWorkoutButton)
    }

}

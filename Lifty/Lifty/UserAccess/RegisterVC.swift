//
//  RegisterVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 13/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class RegisterVC: FormViewController {
    
    @IBOutlet weak var RegisteredButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        self.initiateNameForm()
        self.initiateEmailForm()
        self.initiatePasswordForm()
        self.initiateValidationForm()
    }
    
    func initiateNameForm() {
        form +++
            Section()
            
            <<< TextRow("name") {
                $0.title = "Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            
            <<< TextRow("surname") {
                $0.title = "Surname"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    func initiateEmailForm() {
        form
            +++ Section()
            <<< EmailRow("email") {
                $0.title = "Email adress"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    
    
    func initiatePasswordForm() {
        form
            +++ Section()
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 20))
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            <<< PasswordRow() {
                $0.title = "Confirm Password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    
    func initiateValidationForm() {
        form
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Register"
            }
            .onCellSelection { cell, row in
                var allValid = true
                for row in self.form.rows {
                    if !row.isValid {
                        allValid = false
                    }
                }
                if allValid == true {
                    //                    add user to firebase
                    let emailRow: EmailRow? = self.form.rowBy(tag: "email")
                    let email = emailRow!.value!
                    let passwordRow: PasswordRow? = self.form.rowBy(tag: "password")
                    let password = passwordRow!.value!
                    let nameRow: TextRow? = self.form.rowBy(tag: "name")
                    let name = nameRow!.value!
                    let surnameRow: TextRow? = self.form.rowBy(tag: "surname")
                    let surname = surnameRow!.value!
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                            guard let strongSelf = self else { return }
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = name + " " + surname
                            changeRequest?.commitChanges { (error) in
                                self!.performSegue(withIdentifier: "RegisteredSegue", sender: self!.RegisteredButton)
                            }
                        }
                    }
                }
            }.cellUpdate { cell, row in
                let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
        }
    }
}

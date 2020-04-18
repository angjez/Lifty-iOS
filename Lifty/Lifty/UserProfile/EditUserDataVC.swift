//
//  EditUserDataVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

protocol sendUpdatedUsername {
    func sendUpdatedUsernameToUserDisplay(username: String)
}

class EditUserDataVC: FormViewController, passTheme {
    
    let viewCustomisation = ViewCustomisation()
    
    var delegate: sendUpdatedUsername? = nil
    var theme: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: self.theme!)
        
        self.initiateNameForm()
        self.initiateEmailForm()
        self.initiatePasswordForm()
    }
    
    func finishPassing(theme: UIColor, gradient: UIImage) {
        self.theme = theme
    }
    
    func initiateNameForm() {
        form +++
            Section()
        let user = Auth.auth().currentUser
        if let user = user {
            let fullName = user.displayName!.components(separatedBy: " ")
            form +++
                Section()
                
                <<< TextRow("name") {
                    $0.title = "Name"
                    $0.value = fullName[0]
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
                    $0.value = fullName[1]
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
    }
    func initiateEmailForm() {
        let user = Auth.auth().currentUser
        if let user = user {
            form
                +++ Section()
                <<< EmailRow("email") {
                    $0.title = "Email adress"
                    $0.value = user.email
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
    }
    
    
    func initiatePasswordForm() {
        form
            +++ Section()
            <<< PasswordRow("newpassword") {
                $0.title = "New password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 20))
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
                $0.title = "Confirm new password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "newpassword"))
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
    
    override func viewWillDisappear(_ animated: Bool) {
        var allValid = true
        for row in self.form.rows {
            if !row.isValid {
                allValid = false
            }
        }
        if allValid == true {
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                let emailRow: EmailRow? = self.form.rowBy(tag: "email")
                if (emailRow!.value != user.email){
                    Auth.auth().currentUser?.updateEmail(to: emailRow!.value!) { (error) in
                      // ...
                    }
                }
                
                let passwordRow: PasswordRow? = self.form.rowBy(tag: "newpassword")
                if (passwordRow!.value != nil) {
                    Auth.auth().currentUser?.updatePassword(to: passwordRow!.value!) { (error) in
                      // ...
                    }
                }
                
                let nameRow: TextRow? = self.form.rowBy(tag: "name")
                let surnameRow: TextRow? = self.form.rowBy(tag: "surname")
                if (nameRow!.value! + " " + surnameRow!.value!) != user.displayName {
                    changeRequest?.displayName = nameRow!.value! + " " + surnameRow!.value!
                    self.delegate?.sendUpdatedUsernameToUserDisplay(username: (nameRow!.value! + " " + surnameRow!.value!))
                }
                let userDocument = UserDocument(uid: user.uid)
                userDocument.setUserDocument(name: nameRow!.value!, surname: surnameRow!.value!, email: emailRow!.value!)
                changeRequest?.commitChanges { (error) in
                }
            }
        }
    }
    
}

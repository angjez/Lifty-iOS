//
//  NewWorkout.swift
//  WODder
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka



class NewWorkout: FormViewController {
    
    var workoutTypes =  ["AMRAP","EMOM","for time","tabata"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++

              TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
              }
        
//        workout types
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }

        form +++
            Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["FOR TIME", "EMOM", "AMRAP", "TABATA"]
                $0.value = "FOR TIME"
            }
            +++ Section(){
                $0.tag = "for_time_t"
                $0.hidden = "$segments != 'FOR TIME'" // .Predicate(NSPredicate(format: "$segments != 'FOR TIME'"))
            }
            
            <<< IntRow() {
                $0.title = "Time cap:"
                $0.placeholder = "in minutes"
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
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

            <<< IntRow() {
                $0.title = "Rounds:"
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleSmallerThan(max: 1000))
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


            +++ Section(){
                $0.tag = "emom_t"
                $0.hidden = "$segments != 'EMOM'"
            }
            <<< TextRow(){
                $0.title = "Which music style do you like most?"
            }

            <<< TextRow(){
                $0.title = "Which is your favourite singer?"
            }
            <<< TextRow(){
                $0.title = "How many CDs have you got?"
            }

            +++ Section(){
                $0.tag = "amrap_t"
                $0.hidden = "$segments != 'AMRAP'"
            }
            <<< TextRow(){
                $0.title = "Which is your favourite actor?"
            }

            <<< TextRow(){
                $0.title = "Which is your favourite film?"
            }
        
        +++ Section(){
            $0.tag = "tabata_t"
            $0.hidden = "$segments != 'TABATA'"
        }
        <<< TextRow(){
            $0.title = "Which is your favourite actor?"
        }

        <<< TextRow(){
            $0.title = "Which is your favourite film?"
        }
        
//        add exercises
        var index = 1
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete]) {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add another exercise"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                            index += 1
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return LabelRow () {
                                        $0.title = "Exercise \(index)"
                                        $0.value = "tap to edit"
                                        }
                                        .onCellSelection { cell, row in
                                            row.title = (row.title ?? "") + " 🇺🇾 "
                                            row.reload() // or row.updateCell()
                                    }
                                }
                                $0  <<< LabelRow () {
                                    $0.title = "Exercise \(index)"
                                    $0.value = "tap to edit"
                                    }
                                    .onCellSelection { cell, row in
                                        row.title = (row.title ?? "") + " 🇺🇾 "
                                        row.reload() // or row.updateCell()
                                }
                            }

            }
        
    }
    


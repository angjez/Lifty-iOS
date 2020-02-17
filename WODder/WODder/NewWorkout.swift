//
//  NewWorkout.swift
//  WODder
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka


class NewWorkout: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var TypeTextField: UITextField!
    
    var workoutTypes =  ["AMRAP","EMOM","for time","tabata"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
    }

    //MARK: - TypePicker
    
    func createPickerView() {
           let typePicker = UIPickerView()
           typePicker.delegate = self
            typePicker.dataSource = self
           TypeTextField.inputView = typePicker
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       TypeTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return workoutTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return workoutTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TypeTextField.text = workoutTypes[row]
    }

}

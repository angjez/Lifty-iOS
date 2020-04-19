//
//  Alert.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit

class AlertView: NSObject {
    class func showInvalidDataAlert(view: UIViewController, theme: UIColor){
        let alert = UIAlertController(title: "Required fields are empty.", message: "Leave without saving?", preferredStyle: .alert)
        alert.view.tintColor = theme
        
        let leaveAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            view.navigationController?.popToRootViewController(animated: true)
            view.navigationController?.setNavigationBarHidden(false, animated: true)
        })
        alert.addAction(leaveAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
    }
}
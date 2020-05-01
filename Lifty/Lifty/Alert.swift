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
            view.navigationController!.popViewController(animated: true)
        })
        alert.addAction(leaveAction)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    class func showAchievementUnlockedAlert(view: UIViewController, theme: UIColor, achievementType: String, achievementLevel: Int, completion: @escaping (()) -> Void){
        let alert = UIAlertController(title: "Congratulations!", message: "You ulocked an achievement: level \(achievementType) in \(achievementType)!", preferredStyle: .alert)
        alert.view.tintColor = theme
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            completion(())
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
}

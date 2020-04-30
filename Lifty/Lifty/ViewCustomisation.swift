//
//  ViewCustomisation.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import AnimatedGradientView

class ViewCustomisation {
    
    //    MARK: Gradient customisation.
    
    func setPinkGradients (viewController: UIViewController) {
        guard let tabBarController = viewController.tabBarController
            else {
                print("Error initializing tab bar controller!")
                return
        }
        guard let navigationController = viewController.navigationController
            else {
                print("Error initializing navigation controller!")
                return
        }
        guard
            let pinkGradientImageTabBar = CAGradientLayer.pinkGradient(on: tabBarController.tabBar)
            else {
                print("Error creating gradient color!")
                return
        }
        tabBarController.tabBar.barTintColor = UIColor(patternImage: pinkGradientImageTabBar)
        
        guard
            let pinkGradientImageNavBar = CAGradientLayer.pinkGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: pinkGradientImageNavBar)
    }
    
    func setBlueGradients (viewController: UIViewController) {
        guard let tabBarController = viewController.tabBarController
            else {
                print("Error initializing tab bar controller!")
                return
        }
        guard let navigationController = viewController.navigationController
            else {
                print("Error initializing navigation controller!")
                return
        }
        guard
            let blueGradientImageTabBar = CAGradientLayer.blueGradient(on: tabBarController.tabBar)
            else {
                print("Error creating gradient color!")
                return
        }
        tabBarController.tabBar.barTintColor = UIColor(patternImage: blueGradientImageTabBar)
        
        guard
            let blueGradientImageNavBar = CAGradientLayer.blueGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: blueGradientImageNavBar)
        navigationController.view.backgroundColor = UIColor(patternImage: blueGradientImageNavBar)
    }
    
    func setBackgroundGradient (view: UIView) {
        
        guard
            let blueGradientColor = CAGradientLayer.blueGradient(on: view)
            else {
                print("Error creating gradient color!")
                return
        }
        
        view.backgroundColor = UIColor(patternImage: blueGradientColor)
    }
    
//    func animatedGradientView(view: UIView) -> UIView {
//        let animatedGradient = AnimatedGradientView(frame: view.bounds)
//        animatedGradient.animations = [
//        AnimatedGradientView.Animation(colorStrings: ["#8686E6", "#5E5CE6"], direction: .up, locations: [0.0, 0.5, 1.0], type: .axial),
//        AnimatedGradientView.Animation(colorStrings: ["#91CC00", "#30D33B"], direction: .upRight, locations: [0.0, 0.5, 1.0], type: .axial),
//        AnimatedGradientView.Animation(colorStrings: ["#FF7471", "#FF375F"], direction: .upRight, locations: [0.0, 0.5, 1.0], type: .axial)
//        ]
//        return animatedGradient
//    }
    
    //    MARK: Tableview customisation.
    
    func customiseTableView (tableView: UITableView, themeColor: UIColor) {
        tableView.preservesSuperviewLayoutMargins = false
        tableView.rowHeight = 70
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = themeColor
        tableView.backgroundColor = UIColor.white
        tableView.frame = CGRect(x: 20, y: (tableView.frame.origin.y), width: (tableView.frame.size.width)-40, height: (tableView.frame.size.height))
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setLabelRowCellProperties (cell: UITableViewCell, textColor: UIColor, borderColor: UIColor) {
        cell.textLabel!.textColor = textColor
        cell.indentationLevel = 2
        cell.indentationWidth = 10
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = borderColor.cgColor
        cell.layer.borderWidth = 3.0
        cell.contentView.layoutMargins.right = 20
    }
}

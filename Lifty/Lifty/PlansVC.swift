//
//  SecondViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka

class PlansVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
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
        
        setGradients(tabBarController: tabBarController, navigationController: navigationController, view: self.view, tableView: self.tableView)
    
    }
}


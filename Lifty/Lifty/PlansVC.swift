//
//  SecondViewController.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit

class PlansVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setGradients()
    
    }
    
    func setGradients () {
            guard
                let tabBarController = tabBarController,
                let flareGradientImageTabBar = CAGradientLayer.primaryGradient(on: tabBarController.tabBar)
                else {
                    print("Error creating gradient color!")
                    return
                }
            tabBarController.tabBar.barTintColor = UIColor(patternImage: flareGradientImageTabBar)
            
            guard
                let navigationController = navigationController,
                let flareGradientImageNavBar = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
                else {
                    print("Error creating gradient color!")
                    return
                }

            navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImageNavBar)
        
            
            guard
                let flareGradientImage = CAGradientLayer.primaryGradient(on: self.view)
                else {
                    print("Error creating gradient color!")
                    return
                }
            
            self.view.backgroundColor = UIColor(patternImage: flareGradientImage)
    }
}


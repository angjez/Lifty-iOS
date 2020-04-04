//
//  UIextensions.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 28/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Foundation

extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let red = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        let orange = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [red.cgColor, orange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

func setGradients (tabBarController: UITabBarController, navigationController: UINavigationController, view: UIView, tableView: UITableView) {
        guard
            let flareGradientImageTabBar = CAGradientLayer.primaryGradient(on: tabBarController.tabBar)
            else {
                print("Error creating gradient color!")
                return
            }
        tabBarController.tabBar.barTintColor = UIColor(patternImage: flareGradientImageTabBar)
        
        guard
            let flareGradientImageNavBar = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
            }

        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImageNavBar)
    
        
        guard
            let flareGradientImage = CAGradientLayer.primaryGradient(on: view)
            else {
                print("Error creating gradient color!")
                return
            }
        
        view.backgroundColor = UIColor(patternImage: flareGradientImage)
        tableView.backgroundColor = UIColor(patternImage: flareGradientImage)
}

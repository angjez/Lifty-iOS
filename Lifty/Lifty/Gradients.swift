//
//  UIextensions.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 28/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Foundation

protocol passTheme {
    func finishPassing (theme: UIColor, gradient: UIImage)
}

extension CAGradientLayer {
    
    class func blueGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let indigo = #colorLiteral(red: 0.368627451, green: 0.3607843137, blue: 0.9019607843, alpha: 1)
        let lightIndigo = #colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.9019607843, alpha: 1)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [indigo.cgColor, lightIndigo.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createBlueGradientImage(on: view)
    }
    
    private func createBlueGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    class func pinkGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let pink = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
        let lightPeachPink = #colorLiteral(red: 0.9983616471, green: 0.4554040432, blue: 0.442511797, alpha: 1)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [pink.cgColor, lightPeachPink.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createBlueGradientImage(on: view)
    }
    
    private func createPinkGradientImage(on view: UIView) -> UIImage? {
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

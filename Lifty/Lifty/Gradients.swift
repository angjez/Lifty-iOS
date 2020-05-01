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
        gradient.colors = [indigo.cgColor, lightIndigo.cgColor]
        setGradientBounds(gradient: gradient, view: view)
        return gradient.createGradientImage(on: view)
    }
    
    class func pinkGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let pink = #colorLiteral(red: 1, green: 0.2156862745, blue: 0.3725490196, alpha: 1)
        let lightPeachPink = #colorLiteral(red: 0.9983616471, green: 0.4554040432, blue: 0.442511797, alpha: 1)
        gradient.colors = [pink.cgColor, lightPeachPink.cgColor]
        setGradientBounds(gradient: gradient, view: view)
        return gradient.createGradientImage(on: view)
    }
    
    class func greenGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let green = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 1)
        let limeGreen = #colorLiteral(red: 0.628940165, green: 0.8212791085, blue: 0, alpha: 1)
        gradient.colors = [green.cgColor, limeGreen.cgColor]
        setGradientBounds(gradient: gradient, view: view)
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

func setGradientBounds(gradient: CAGradientLayer, view: UIView) {
    var bounds = view.bounds
    bounds.size.height += UIApplication.shared.statusBarFrame.size.height
    gradient.frame = bounds
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 0)
}

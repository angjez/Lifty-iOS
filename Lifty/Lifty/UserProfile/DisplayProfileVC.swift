//
//  DisplayProfileVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit


class DisplayProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (globalPlansVC?.tabBarController?.selectedIndex != nil) &&  (globalPlansVC?.tabBarController!.selectedIndex == 1){
            self.theme = .systemPink
            gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        } else if (globalSavedWorkoutsVC?.tabBarController?.selectedIndex != nil) && (globalSavedWorkoutsVC?.tabBarController!.selectedIndex == 0) {
            self.theme = .systemIndigo
            gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        }
        
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.clipsToBounds = true
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DisplayProfileVC.imageTapped(gesture:)))
        ProfileImageView.addGestureRecognizer(tapGesture)
        ProfileImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            displayActionSheet(self)
        }
    }
    
    @IBAction func displayActionSheet(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        optionMenu.view.tintColor = self.theme
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.ProfileImageView.image = UIImage(systemName: "person.crop.circle")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        self.ProfileImageView.image = image
    }
    
}

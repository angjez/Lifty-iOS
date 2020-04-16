//
//  DisplayProfileVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase

class DisplayProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, sendUpdatedUsername {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var NameSurnameLabel: UILabel!
    
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (globalPlansVC?.tabBarController?.selectedIndex != nil) &&  (globalPlansVC?.tabBarController!.selectedIndex == 1){
            self.theme = .systemPink
            gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        } else if (globalWorkoutsVC?.tabBarController?.selectedIndex != nil) && (globalWorkoutsVC?.tabBarController!.selectedIndex == 0) {
            self.theme = .systemIndigo
            gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        }
        
        imageViewSetup()
        labelSetup()
    }
    
    func sendUpdatedUsernameToUserDisplay(username: String) {
        self.NameSurnameLabel.text = username
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "EditUserDataSegue" {
            let senderVC: EditUserDataVC = segue.destination as! EditUserDataVC
            senderVC.delegate = self
        }
    }
    
    func labelSetup () {
        let user = Auth.auth().currentUser
        if let user = user {
            NameSurnameLabel.text = user.displayName
            NameSurnameLabel.textColor = UIColor(patternImage: gradientImage)
        }
    }
    
    func imageViewSetup () {
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.clipsToBounds = true
        self.ProfileImageView.layer.borderWidth = 3.0
        self.ProfileImageView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DisplayProfileVC.imageTapped(gesture:)))
        ProfileImageView.addGestureRecognizer(tapGesture)
        ProfileImageView.isUserInteractionEnabled = true
        
        let arr = ImageManagement.shareInstance.fetchImage()
        if (!arr.isEmpty) {
            ProfileImageView.image = UIImage(data: arr[0].image!)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func editUserData(_ sender: Any) {
        self.performSegue(withIdentifier: "EditUserDataSegue", sender: sender)
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
            ImageManagement.shareInstance.deleteImage()
            deleteAllRecords(name: "UserImageEntity")
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
        deleteAllRecords(name: "UserImageEntity")
        
        self.ProfileImageView.image = image
        if let imageData = ProfileImageView.image?.pngData() {
            ImageManagement.shareInstance.saveImage(data: imageData)
        }
    }
    
}

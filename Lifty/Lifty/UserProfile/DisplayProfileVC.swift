//
//  DisplayProfileVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase

class DisplayProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, sendUpdatedUsername, passTheme {
    
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var NameSurnameLabel: UILabel!
    @IBOutlet weak var achievementCollectionView: UICollectionView!
    
    var themeDelegate: passTheme?
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    var achievements = [AchievementCVModel]()
    var achievementStats = [String:[Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAchievements()
        
        self.achievementCollectionView.dataSource = self
        self.achievementCollectionView.delegate = self
        self.achievementCollectionView.register(UINib.init(nibName: "AchievementCVCell", bundle: nil), forCellWithReuseIdentifier: "AchievementCVCell")
        
        imageViewSetup()
        labelSetup()
    }
    
    // MARK: Protocol stubs.
    
    func sendUpdatedUsernameToUserDisplay(username: String) {
        self.NameSurnameLabel.text = username
    }
    
    func finishPassing(theme: UIColor, gradient: UIImage) {
        self.theme = theme
        self.gradientImage = gradient
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUserDataSegue" {
            let senderVC: EditUserDataVC = segue.destination as! EditUserDataVC
            senderVC.delegate = self
        }
        if let destinationVC = segue.destination as? EditUserDataVC{
            self.themeDelegate = destinationVC
            self.themeDelegate?.finishPassing(theme: self.theme!, gradient: self.gradientImage)
        }
    }
    
    // MARK: Element setups.
    
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
    
    // MARK: Button methods.
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            ImageManagement.shareInstance.deleteImageFromCoreData()
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
    
    // MARK: User image methods.
    
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
            ImageManagement.shareInstance.deleteImageFromCoreData()
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
        ImageManagement.shareInstance.deleteImageFromCoreData()
        
        self.ProfileImageView.image = image
        if let imageData = ProfileImageView.image?.pngData() {
            ImageManagement.shareInstance.saveImage(data: imageData)
        }
    }

}

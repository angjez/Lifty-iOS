//
//  FirstViewController.swift
//  WODder
//
//  Created by Angelika Jeziorska on 08/12/2019.
//  Copyright © 2019 Angelika Jeziorska. All rights reserved.
//

import UIKit

class SavedWODs: UIViewController {
    
    
    
    @IBOutlet weak var AddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }

    @IBAction func AddButtonTapped(_ sender: Any) {
        
    }
    
    func workoutPressedActionSheet(controller: UIViewController) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
//            proceed to editing
        }))

        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (_) in
//            proceed to selecting
        }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
//            proceed to deleting
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
//            dismiss
        }))

        self.present(alert, animated: true)
    }
    
}


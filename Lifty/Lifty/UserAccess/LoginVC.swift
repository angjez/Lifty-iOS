//
//  LoginVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 13/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var LoggedButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var ForgotPasswordButton: UIButton!
    
    @IBOutlet weak var ErrorMessageLabel: UILabel!
    
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "LoggedSegue"{
            if (LoginTextField.text == nil) || (PasswordTextField.text == nil) {
                return false
            }
            let email = LoginTextField.text!
            let password = PasswordTextField.text!
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
            }
            let user = Auth.auth().currentUser
            if(user == nil) {
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient(view: self.view)
        self.setPadding(textField: PasswordTextField)
        self.setPadding(textField: LoginTextField)
        self.setBorders(button: LoginButton)
        self.setBorders(button: RegisterButton)
        
    }
    
    func setBorders (button : UIButton) {
        button.contentEdgeInsets = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15);
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3.0
    }
    
    func setPadding (textField: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
}

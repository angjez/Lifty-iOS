//
//  UserDocumentManagement.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class UserDocument : Document {
    
    var name: String?
    var surname: String?
    var email: String?
    var userRef: DocumentReference? = nil
    
    override init(uid: String) {
        super.init(uid: uid)
        self.userRef = db.collection("users").document(self.uid)
    }
    
    func setUserDocument (name: String, surname: String, email: String) {
        self.userRef!.setData([
            "name": name,
            "surname": surname,
            "email": email
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}

//
//  UserDocumentManagement.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class UserDocument {
    let db = Firestore.firestore()
    
    var name: String?
    var surname: String?
    var email: String?
    var uid: String
    var userRef: DocumentReference? = nil
    
    init(uid: String) {
        self.uid = uid
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

//
//  Document.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class Document {
    let db = Firestore.firestore()
    var uid: String
    
    init(uid: String) {
        self.uid = uid
    }
}

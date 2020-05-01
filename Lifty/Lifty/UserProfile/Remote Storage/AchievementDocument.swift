//
//  AchievementDocument.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 30/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class AchievementDocument : Document {
    
    var name: String?
    var surname: String?
    var email: String?
    var achievementRef: DocumentReference? = nil
    
    override init(uid: String) {
        super.init(uid: uid)
        self.achievementRef = db.collection("achievements").document(self.uid)
    }
    
    func getAchievementDocument (completion: @escaping ([String:Any]) -> Void) {
        var loadedAchievements = [String:Any]()
        self.achievementRef?.getDocument { (querySnapshot, err) in
            if let err = err {
                completion(loadedAchievements)
                print("Error getting documents: \(err)")
            } else {
                loadedAchievements = querySnapshot!.data()!
                completion(loadedAchievements)
            }
        }
    }
    
    func setAchievementDocument (achievementDictionary: [String:Any]) {
        self.achievementRef!.setData(achievementDictionary)
    }
    
}


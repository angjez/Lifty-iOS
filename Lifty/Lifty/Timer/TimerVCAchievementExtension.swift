//
//  TimerVCAchievementExtension.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 01/05/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase
import UIKit

extension TimerVC {
    
    // MARK: Achievement data management.
    
    func updateAchievementData() {
        let user = Auth.auth().currentUser
        if let user = user {
            let achievementDocument = AchievementDocument(uid: user.uid)
            achievementDocument.getAchievementDocument(completion: { loadedAchievements in
                var achievementStats = loadedAchievements as! [String:[Int]]
                print(achievementStats)
                achievementStats = self.incrementWorkoutInDict(dict: achievementStats)
                achievementStats = self.incrementWorkoutTimeInDict(dict: achievementStats, key: "Workout record")
                achievementStats = self.incrementWorkoutTimeInDict(dict: achievementStats, key: "Time record")
                print(achievementStats)
                // save changes to Firestore
                achievementDocument.setAchievementDocument(achievementDictionary: achievementStats)
            })
        }
    }
    
    func incrementWorkoutInDict(dict:[String:[Int]])->[String:[Int]] {
        var mutatedDict = dict
        for (key, _) in mutatedDict {
            let achievementWorkoutType = key.components(separatedBy: " ").first
            let currentWorkoutType = self.currentWorkout?.type.components(separatedBy: " ").first
            if achievementWorkoutType == currentWorkoutType {
                mutatedDict[key]![1] += 1
                if mutatedDict[key]![1] == mutatedDict[key]![2] {
                    if mutatedDict[key]![0] < 3 {
                        mutatedDict[key]![2] = mutatedDict[key]![2] * (6 - mutatedDict[key]![0])
                        mutatedDict[key]![0] += 1
                    } else if mutatedDict[key]![0] == 3 {
                        mutatedDict[key]![2] = 1000
                        mutatedDict[key]![0] += 1
                    }
                }
                return mutatedDict
            }
        }
        return mutatedDict
    }
    
    func incrementWorkoutTimeInDict(dict:[String:[Int]], key: String)->[String:[Int]]  {
        var mutatedDict = dict
        mutatedDict[key]![1] += 1
        if mutatedDict[key]![1] == mutatedDict[key]![2] {
            if mutatedDict[key]![0] < 3 {
                mutatedDict[key]![2] = mutatedDict[key]![2] * (6 - mutatedDict[key]![0])
                mutatedDict[key]![0] += 1
            } else if dict[key]![0] == 3 {
                mutatedDict[key]![2] = 3000
                mutatedDict[key]![0] += 1
            }
        }
        return mutatedDict
    }
    
}

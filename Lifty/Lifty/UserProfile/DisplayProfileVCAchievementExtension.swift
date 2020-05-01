//
//  DisplayProfileVCAchievementExtension.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 30/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension DisplayProfileVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: AchievementCollectionView methods.
    
    func addAchievements() {
        let user = Auth.auth().currentUser
        if let user = user {
            let achievementDocument = AchievementDocument(uid: user.uid)
            achievementDocument.getAchievementDocument(completion: { loadedAchievements in
                let achievementStats = loadedAchievements as! [String:[Int]]
                print(achievementStats)
                let achievementIcons = ["flame.fill", "hourglass", "playpause.fill", "bolt.fill", "burst.fill", "timer"]
                for n in 0...achievementStats.count-1 {
                    let dictKey = Array(achievementStats.keys)[n]
                    self.achievements.append(AchievementCVModel(achievementIcon: UIImage(systemName: achievementIcons[n])!, achievementLabel: dictKey, achievementLevelLabel: achievementStats[dictKey]![0], progress: Float(achievementStats[dictKey]![1]), total: Float(achievementStats[dictKey]![2])))
                }
                self.achievementCollectionView.reloadData()
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCVCell", for: indexPath) as! AchievementCVCell
        cell.configure(with: achievements[indexPath.row], with: self.theme!)
        return cell
    }
    
}

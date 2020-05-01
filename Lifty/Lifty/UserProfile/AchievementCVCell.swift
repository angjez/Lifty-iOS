//
//  AchievementCVCell.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 30/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

struct AchievementCVModel {
    let achievementIcon: UIImage
    let achievementLabel: String
    let achievementLevelLabel: Int
    let progress: Float
    let total: Float
}

class AchievementCVCell: UICollectionViewCell {
    
    @IBOutlet weak var achievementIcon: UIImageView!
    @IBOutlet weak var achievementProgressBar: UIProgressView!
    @IBOutlet weak var achievementLevelLabel: UILabel!
    @IBOutlet weak var achievementLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.achievementLevelLabel.layer.cornerRadius = 0.5 * self.achievementLevelLabel.bounds.size.width
        achievementLevelLabel.clipsToBounds = true
    }
    
    public func configure(with model: AchievementCVModel, with color: UIColor) {
        achievementIcon.image = model.achievementIcon
        achievementIcon.tintColor = color
        achievementLabel.text = model.achievementLabel
        achievementLevelLabel.text = String(model.achievementLevelLabel)
        achievementProgressBar.progress = model.progress/model.total
        achievementProgressBar.progressTintColor = color
    }

}

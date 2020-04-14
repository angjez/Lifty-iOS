//
//  ImageSaver.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper {
    static let shareInstance = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func saveImage(data: Data) {
        let imageInstance = UserImageEntity(context: context)
        imageInstance.image = data
        do {
            try context.save()
            print("Image is saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage() -> [UserImageEntity] {
        var fetchingImage = [UserImageEntity]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserImageEntity")
        do {
            fetchingImage = try context.fetch(fetchRequest) as! [UserImageEntity]
        } catch {
            print("Error while fetching the image")
        }
        return fetchingImage
    }
}


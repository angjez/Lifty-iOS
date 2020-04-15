//
//  DeleteCoreDataEntities.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func deleteAllRecords(name: String) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    
    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
    do {
        try context.execute(deleteRequest)
        try context.save()
    } catch {
        print ("There was an error")
    }
}

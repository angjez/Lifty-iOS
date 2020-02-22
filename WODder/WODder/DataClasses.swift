//
//  DataClasses.swift
//  WODder
//
//  Created by Angelika Jeziorska on 22/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class Exercise {
    var name: String
    var type: String
    var reps: Int?
    var time: String?
    var notes: String?
    
    init(name: String, type: String, reps: Int, time: String, notes: String) {
        self.name = name
        self.type = type
        self.reps = reps
        self.time = time
        self.notes = notes
    }
}

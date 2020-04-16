//
//  WorkoutProtocols.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 16/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Eureka

protocol passWorkout {
    func finishPassing (chosenWorkout: Workout)
}

protocol passExercise {
    func finishPassing (chosenExercise: Exercise, chosenRow: ButtonRowOf<String>?)
}

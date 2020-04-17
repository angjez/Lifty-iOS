//
//  PlanDocument.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class PlanDocument : Document {

    var collectionRef: CollectionReference? = nil
    
    override init(uid: String) {
        super.init(uid: uid)
        self.collectionRef = db.collection("plans")
    }
    
//    MARK: Methods for setting values for plans.
    
    func setPlanDocument (plan: Plan) {
        let batch = db.batch()
        let planRef = self.collectionRef!.document(self.uid).collection("plans").document(plan.name)
        batch.setData([
            "name": plan.name,
        ], forDocument: planRef)
        for (index, week) in plan.weeks.enumerated() {
            setWeekDocument(week: week, index: index, rootDoc: planRef, batch: batch)
        }
    }
    
    func setWeekDocument (week: Week, index: Int, rootDoc: DocumentReference, batch: WriteBatch) {
        let weekRef = rootDoc.collection("weeks").document("Week " + String(index))
        batch.setData([
            "week": "Week " + String(index),
        ], forDocument: weekRef)
        for (index, day) in week.days.enumerated() {
            setDayDocument(day: day, index: index, rootDoc: weekRef, batch: batch)
        }
    }
    
    func setDayDocument (day: Day, index: Int, rootDoc: DocumentReference, batch: WriteBatch) {
        let dayRef = rootDoc.collection("days").document("Day " + String(index))
        batch.setData([
            "week": "Day " + String(index),
        ], forDocument: dayRef)
        for workout in day.workouts {
            setWorkoutDocument(workout: workout, rootDoc: dayRef, batch: batch)
        }
    }
    
    func setWorkoutDocument (workout: Workout, rootDoc: DocumentReference, batch: WriteBatch) {
        let workoutRef = rootDoc.collection("workouts").document(workout.name)
        batch.setData([
            workout.name: true
        ], forDocument: workoutRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
//    MARK: Methods for getting the values for plans.
    
}

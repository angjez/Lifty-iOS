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
    
    func setPlanDocument (plan: Plan, completion: @escaping () -> Void) {
        let batch = db.batch()
        let planRef = self.collectionRef!.document(self.uid).collection("plans").document(plan.name)
        batch.setData([
            "name": plan.name,
        ], forDocument: planRef)
        for (index, week) in plan.weeks.enumerated() {
            setWeekDocument(week: week, index: index, rootDoc: planRef, batch: batch)
        }
        batch.commit() { err in
            if let err = err {
                completion()
                print("Error writing batch \(err)")
            } else {
                completion()
                print("Batch write succeeded.")
            }
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
    }
    
    //    MARK: Methods for getting the values for plans.
    
    func getPlanDocument (completion: @escaping ([Plan]) -> Void)  {
        var loadedPlans = [Plan]()
        self.collectionRef!.document(self.uid).collection("plans").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(loadedPlans)
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let plan = Plan(name: "")
                    for data in document.data() {
                        if data.key == "name" {
                            plan.name = data.value as! String
                        }
                    }
                    self.getPlanWeeks(planName: plan.name, completion: { weeks in
                        plan.weeks = weeks
                    })
                    loadedPlans.append(plan)
                }
                completion(loadedPlans)
            }
        }
    }
    
    func getPlanWeeks (planName: String, completion: @escaping ([Week]) -> Void) {
        var weeks = [Week]()
        self.collectionRef!.document(self.uid).collection("plans").document(planName).collection("weeks").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(weeks)
                print("Error getting documents: \(err)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    let week = Week()
                    let docRef = self.collectionRef!.document(self.uid).collection("plans").document(planName).collection("weeks").document("Week " + String(index))
                    self.getWeekDays(docRef: docRef, completion: { days in
                        week.days = days
                    })
                    weeks.append(week)
                }
                completion(weeks)
            }
        }
    }
    
    func getWeekDays (docRef: DocumentReference, completion: @escaping ([Day]) -> Void) {
        var days = [Day]()
        docRef.collection("days").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(days)
                print("Error getting documents: \(err)")
            } else {
                for (index, _) in querySnapshot!.documents.enumerated() {
                    let day = Day()
                    let workoutDocRef = docRef.collection("days").document("Day " + String(index))
                    self.getDayWorkouts(workoutDocRef: workoutDocRef, completion: { workouts in
                        print(workouts.count)
                        day.workouts = workouts
                    })
                    days.append(day)
                }
                completion(days)
            }
        }
    }
    
    func getDayWorkouts (workoutDocRef: DocumentReference, completion: @escaping ([Workout]) -> Void) {
        var workouts = [Workout]()
        var allWorkouts = [Workout]()
        let workoutDocument = WorkoutDocument(uid: uid)
        workoutDocument.getWorkoutDocument(completion: { loadedWorkouts in
            allWorkouts = loadedWorkouts
            workoutDocRef.collection("workouts").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(workouts)
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        for data in document.data() {
                            for workout in allWorkouts {
                                if workout.name == data.key {
                                    workouts.append(workout)
                                }
                            }
                        }
                    }
                    completion(workouts)
                }
            }
        })
    }
    
    //    MARK: Methods for deleting plans.
    
    func deletePlanDocument (plan: Plan) {
        let batch = db.batch()
        print(plan.name)
        let planRef = self.collectionRef!.document(self.uid).collection("plans").document(plan.name)
        for (index, week) in plan.weeks.enumerated() {
            deleteWeekDocument(week: week, index: index, rootDoc: planRef, batch: batch)
        }
        batch.deleteDocument(planRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func deleteWeekDocument (week: Week, index: Int, rootDoc: DocumentReference, batch: WriteBatch) {
        let weekRef = rootDoc.collection("weeks").document("Week " + String(index))
        for (index, day) in week.days.enumerated() {
            deleteDayAndWeekDocuments(day: day, index: index, rootDoc: weekRef, batch: batch)
        }
        batch.deleteDocument(weekRef)
    }
    
    func deleteDayAndWeekDocuments (day: Day, index: Int, rootDoc: DocumentReference, batch: WriteBatch) {
        let dayRef = rootDoc.collection("days").document("Day " + String(index))
        for workout in day.workouts {
            let workoutRef = dayRef.collection("workouts").document(workout.name)
            batch.deleteDocument(workoutRef)
        }
        batch.deleteDocument(dayRef)
    }
    
}

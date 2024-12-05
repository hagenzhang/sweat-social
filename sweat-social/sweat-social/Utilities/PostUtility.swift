//
//  PostUtility.swift
//  sweat-social
//

import Foundation
import SwiftUI

/*
let tmpExercise1 = PostExercise(exerciseName: "Pushups", sets: 3, reps: 20, comment: "Unweighted")
let tmpExercise2 = PostExercise(exerciseName: "Bench Press", sets: 3, reps: 6, comment: "135 lb")
let tmpExercise3 = PostExercise(exerciseName: "Sit-Ups", sets: 3, reps: 12, comment: "Unweighted")
let tmpExercise4 = PostExercise(exerciseName: "Treadmill Run", sets: 1, reps: 1, comment: "2 miles in 16 minutes")

let tempPostList = [Post(hours: "1", mins: "30", loc: "home", message: "temp msg 1",
                         exercises: [tmpExercise1, tmpExercise3, tmpExercise4]),
                    Post(hours: "2", mins: "0", loc: "gym 1", message: "temp msg 2",
                         exercises: [tmpExercise2, tmpExercise3]),
                    Post(hours: "1", mins: "0", loc: "gym 2", message: "temp msg 3",
                         exercises: [tmpExercise1, tmpExercise2, tmpExercise4]),
                    Post(hours: "1", mins: "30", loc: "gym 3", message: "temp msg 4",
                         exercises: [tmpExercise1, tmpExercise2, tmpExercise3, tmpExercise4]),
                    Post(hours: "2", mins: "0", loc: "gym 4", message: "temp msg 5",
                         exercises: [tmpExercise3, tmpExercise4]),
                    Post(hours: "1", mins: "0", loc: "gym 5", message: "temp msg 6",
                         exercises: [tmpExercise4])]


struct PostExercise: Identifiable, Codable {
    var id = UUID()
    var exerciseName: String
    var sets: Int
    var reps: Int
    var comment: String
    
    init(exerciseName: String, sets: Int, reps: Int, comment: String) {
        self.exerciseName = exerciseName
        self.sets = sets
        self.reps = reps
        self.comment = comment
    }
}
*/

struct Post: Codable {
    var hours: String
    var mins: String
    var loc: String
    var message: String
    var exercises: String
    var imageRef: String?
    
    init(hours: String, mins: String, loc: String, message: String, exercises: String) {
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.message = message
        self.exercises = exercises
        self.imageRef = nil
        
    }
    
    init(hours: String, mins: String, loc: String, message: String, exercises: [PostExercise], imageRef: String) {
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.message = message
        self.imageRef = imageRef
    }
}

struct PostExerciseTable: View {
    let exercises: [PostExercise]
    
    var body: some View {
        Table(exercises) {
            TableColumn("Exercise Name", value: \.exerciseName)
            TableColumn("Sets") { exercise in
                Text("\(exercise.sets)")
            }
            TableColumn("Reps") { exercise in
                Text("\(exercise.reps)")
            }
            TableColumn("Comment", value: \.comment)
        }
        .padding()
    }
}

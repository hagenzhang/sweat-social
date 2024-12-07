//
//  PostUtility.swift
//  sweat-social
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

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
    var caption: String
    var exercises: String
    var username: String
    var imageRef: URL
    var timeStamp: Timestamp
    
    init(username: String, hours: String, mins: String, loc: String, caption: String, exercises: String, imageRef: URL, timestamp: Timestamp = Timestamp()) {
        self.username = username
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.caption = caption
        self.imageRef = imageRef
        self.exercises = exercises
        self.timeStamp = timestamp
    }
}


class FirebasePostUtil {
    let database = Firestore.firestore()
    
    func uploadPost(post: Post, completion: @escaping (Bool) -> Void) {
        let postsRef = database.collection("posts")
        print("PostUtility - Uploading Post: \(post)")
        
        do {
            try postsRef.addDocument(from: post) { error in
                if let error = error {
                    print("PostUtility -    Error uploading post: \(error.localizedDescription)")
                    print("") // spacer in logs
                    completion(false)
                } else {
                    print("PostUtility -    Post uploaded successfully")
                    print("") // spacer in logs
                    completion(true)
                }
            }
        } catch {
            print("PostUtility -    Exception while uploading post: \(error.localizedDescription)")
            print("") // spacer in logs
            completion(false)
        }
    }
    
    func getPostsByUser(username: String, completion: @escaping ([Post]) -> Void) {
        print("PostUtility - Fetching Posts by User: \(username)")
        
        database.collection("posts").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user posts: \(error.localizedDescription)")
                completion([])
                return
            }

            let posts = snapshot?.documents.compactMap { try? $0.data(as: Post.self) } ?? []
            completion(posts)
        }
    }
    
}

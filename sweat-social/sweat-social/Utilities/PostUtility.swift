//
//  PostUtility.swift
//  sweat-social
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore


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

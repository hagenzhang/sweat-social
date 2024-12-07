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
        print("PostUtility - Uploading Post: \(post) for User: \(post.username)")
        
        let postsRef = database.collection("posts")
        let userPostsRef = database.collection("users").document(post.username).collection("postRefs")
        
        do {
            let newPostRef = try postsRef.addDocument(from: post) { error in
                if let error = error {
                    print("PostUtility -    Error uploading to Root Post Collection: \(error.localizedDescription)")
                    print("") // spacer in logs
                    completion(false)
                    return
                }
            }
            
            // Add a reference to the post in the user's "posts" sub-collection
            userPostsRef.document(newPostRef.documentID).setData(["postRef": newPostRef.documentID]) { error in
                if let error = error {
                    print("PostUtility -    Error adding post reference to user's posts: \(error.localizedDescription)")
                    print("") // spacer in logs
                    completion(false)
                    return
                } else {
                    print("PostUtility -    Post reference added to user's posts successfully.")
                    print("") // spacer in logs
                    completion(true)
                    return
                }
            }
            
        } catch {
            print("PostUtility -    Exception while uploading to Root Post Collection: \(error.localizedDescription)")
            print("") // spacer in logs
            completion(false)
            return
        }
    }
    
    // Retrieves all of the Posts by a User
    func getPostsByUser(username: String, completion: @escaping ([Post]) -> Void) {
        print("PostUtility - Fetching Posts by User: \(username)")
        
        // Reference to the user's "postRefs" collection
        let userPostsRef = database.collection("users").document(username).collection("postRefs")
        
        userPostsRef.getDocuments { snapshot, error in
            if let error = error {
                print("PostUtility -    Error fetching user posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Use the references in the user's "postRefs" to fetch posts from the main "posts" collection
            let postRefs = snapshot?.documents.compactMap { $0["postRef"] as? String } ?? []
            
            // Fetch the posts in bulk using the retrieved references
            let postsCollection = self.database.collection("posts")
            var posts: [Post] = []
            let dispatchGroup = DispatchGroup()
            
            for postRef in postRefs {
                dispatchGroup.enter()
                postsCollection.document(postRef).getDocument { document, error in
                    if let error = error {
                        print("PostUtility -    Error fetching post from reference: \(error.localizedDescription)")
                    } else if let document = document, document.exists, let post = try? document.data(as: Post.self) {
                        posts.append(post)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print("PostUtility -    Successfully fetched \(posts.count) posts for user: \(username)")
                completion(posts)
            }
        }
    }

    
    // Retrieves all of the Posts from all of the Users that a Target User Follows.
    func getPostsFromFollowedUsers(username: String, completion: @escaping ([Post]) -> Void) {
        let firestore = Firestore.firestore()
        var posts: [Post] = []
        
        // Fetch the list of users the current user is following
        let followingRef = firestore.collection("users").document(username).collection("following")
        
        followingRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("PostUtility -    Error fetching following list: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("PostUtility -    No following data found.")
                completion([])
                return
            }
            
            let followingEmails = documents.compactMap { $0.documentID }
            
            if followingEmails.isEmpty {
                print("PostUtility -    Current user is not following anyone.")
                completion([])
                return
            }
            
            // Fetch posts for each followed user
            let postsRef = firestore.collection("posts")
            
            postsRef.whereField("userRef", in: followingEmails).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("PostUtility -    Error fetching posts: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("PostUtility -    No posts found for followed users.")
                    completion([])
                    return
                }
                
                for document in documents {
                    do {
                        if let post = try document.data(as: Post?.self) {
                            posts.append(post)
                        }
                    } catch {
                        print("PostUtility -    Error decoding post: \(error.localizedDescription)")
                    }
                }
                
                // Sort posts by timestamp (convert Timestamp to Date)
                let sortedPosts = posts.sorted {
                    ($0.timeStamp.dateValue()) > ($1.timeStamp.dateValue())
                }
                
                print("PostUtility - Successfully Found \(sortedPosts.count) posts")
                // Return the sorted posts
                completion(sortedPosts)
            }
        }
    }
}

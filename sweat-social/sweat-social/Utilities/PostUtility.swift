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
    
    var likes: [String] // Array of Strings, stores the usernames of the users who have liked the post
    
    init(username: String, hours: String, mins: String, 
         loc: String, caption: String, exercises: String, 
         imageRef: URL, timestamp: Timestamp = Timestamp(),
         likes: [String]) {
        
        self.username = username
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.caption = caption
        self.imageRef = imageRef
        self.exercises = exercises
        self.timeStamp = timestamp
        self.likes = likes
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
    
    func getPostsFromFollowedUsers(username: String, completion: @escaping ([Post]) -> Void) {
        let firestore = Firestore.firestore()
        var posts: [Post] = []
        let group = DispatchGroup() // To synchronize multiple async calls
        
        // Fetching the list of users the current user is following
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
            
            let followingUsernames = documents.compactMap { $0.documentID }
            print("PostUtility -   Currently following \(followingUsernames.count) people")
            
            if followingUsernames.isEmpty {
                print("PostUtility -    Current user is not following anyone.")
                completion([])
                return
            }
            
            // Fetching posts for each followed user from their `postRefs` sub-collection
            for followedUsername in followingUsernames {
                let userPostsRef = firestore.collection("users").document(followedUsername).collection("postRefs")
                
                group.enter() // Start tracking an async task
                userPostsRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("PostUtility -    Error fetching posts for \(followedUsername): \(error.localizedDescription)")
                        group.leave() // Finish tracking this task
                        return
                    }
                    
                    guard let postRefs = querySnapshot?.documents else {
                        print("PostUtility -    No posts found for \(followedUsername).")
                        group.leave()
                        return
                    }
                    
                    // Fetch each post using its document ID
                    for postRefDoc in postRefs {
                        if let postID = postRefDoc.data()["postRef"] as? String {
                            let postDocRef = firestore.collection("posts").document(postID)
                            
                            group.enter() // Start tracking another async task
                            
                            postDocRef.getDocument { (documentSnapshot, error) in
                                if let error = error {
                                    print("PostUtility -    Error fetching post document: \(error.localizedDescription)")
                                } else if let documentSnapshot = documentSnapshot,
                                          let post = try? documentSnapshot.data(as: Post.self) {
                                    posts.append(post)
                                }
                                group.leave() // Finish tracking this task
                            }
                        }
                    }
                    group.leave() // Finish tracking the userPostsRef task
                }
            }
            
            //  Wait for all tasks to complete and then sort posts by timestamp
            group.notify(queue: .main) {
                print("PostUtility - Post Scanning Completed")
                let sortedPosts = posts.sorted {
                    // Ensure your `Post` struct includes a timestamp field of type `Timestamp`
                    $0.timeStamp.dateValue() > $1.timeStamp.dateValue()
                }
                print("PostUtility - Successfully Found \(sortedPosts.count) posts")
                completion(sortedPosts)
            }
        }
    }
    
    
    func getGlobalPosts(completion: @escaping ([Post]) -> Void) {
        let firestore = Firestore.firestore()
        let postsRef = firestore.collection("posts")
        
        print("PostUtility - Fetching All Posts")
        
        // Use Firestore's order(by:) to sort by the "timeStamp" field
        postsRef.order(by: "timeStamp", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("PostUtility -    Error fetching all posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("PostUtility -    No posts found.")
                completion([])
                return
            }
            
            // Map documents to Post objects
            let posts: [Post] = documents.compactMap { try? $0.data(as: Post.self) }
            
            print("PostUtility - Successfully fetched \(posts.count) posts.")
            completion(posts)
        }
        
    }
    
}

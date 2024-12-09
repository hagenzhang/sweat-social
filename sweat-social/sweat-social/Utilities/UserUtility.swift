//
//  UserUtils.swift
//  sweat-social
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseUserUtil {
    static var currentUser: FirebaseAuth.User?
    let storage = Storage.storage()
    let database = Firestore.firestore()
    
    // Returns a list of usernames in Firebase that matches the search query.
    func findUsersFromQuery(query: String, completion: @escaping (([User]) -> Void)) {
        let currentUsername = FirebaseUserUtil.currentUser!.displayName!
        let usersRef = database.collection("users")
        
        print("UserUtility - Search for users with query: \(query)")
        
        // Perform a query to fetch users whose usernames start with the search query
        let searchEnd = query + "\u{f8ff}"
        usersRef
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: searchEnd)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("UserUtility - Error fetching users: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("UserUtility - No users found.")
                    completion([])
                    return
                }
                
                // Decode the users into User objects
                let users = documents.compactMap { try? $0.data(as: User.self) }.filter { $0.username != currentUsername }
                
                print("UserUtility - Found \(users.count) users matching query '\(query)'")
                completion(users)
            }
    }
    
    
    // Function for adding a follower to a target user based on usernames.
    func addFollowerToTarget(targetUsername: String, followerUsername: String) {
        let targetRef = database.collection("users").document(targetUsername)
        let followerRef = database.collection("users").document(followerUsername)
        
        print("FirebaseUserUtil - \(followerUsername) set to Follow \(targetUsername)")
        
        targetRef.collection("followers").document(targetUsername).setData(["reference": followerRef]) { error in
            if error == nil {
                print("FirebaseUserUtil -    Follower to Target added successfully.")
                
                followerRef.collection("following").document(targetUsername).setData(["reference": targetRef]) { error in
                    if error == nil {
                        print("FirebaseUserUtil -    Following from Follower added successfully.")
                    } else {
                        print("FirebaseUserUtil -    Error adding Following.")
                    }
                }
                
            } else {
                print("FirebaseUserUtil -    Error adding follower: \(error!.localizedDescription)")
            }
        }
    }
    
    // Function for removing a follower from a target user based on usernames.
    func removeFollowerFromTarget(targetUsername: String, followerUsername: String) {
        let targetRef = database.collection("users").document(targetUsername)
        let followerRef = database.collection("users").document(followerUsername)
        
        print("FirebaseUserUtil - \(followerUsername) set to UnFollow \(targetUsername)")
        
        // Remove the follower from the target user's Followers collection
        targetRef.collection("followers").document(followerUsername).delete { error in
            if error == nil {
                print("FirebaseUserUtil -    follower removed successfully")
                
                // Remove the target user from the follower's Following collection
                followerRef.collection("following").document(targetUsername).delete { error in
                    if error == nil {
                        print("FirebaseUserUtil -    target removed successfully")
                    } else {
                        print("FirebaseUserUtil -    Error removing target from follower: \(error!.localizedDescription)")
                    }
                }
            } else {
                print("FirebaseUserUtil -    Error removing follower from target: \(error!.localizedDescription)")
            }
        }
    }
    
    // Function to get a User's followers.
    func getFollowers(username: String, completion: @escaping ([String]) -> Void) {
        let followersRef = database.collection("users").document(username).collection("followers")
        
        followersRef.getDocuments { snapshot, error in
            if let error = error {
                print("FirebaseUserUtil - Error fetching followers: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("FirebaseUserUtil - No followers found for user: \(username)")
                completion([])
                return
            }
            
            let followers = documents.map { $0.documentID }
            
            print("FirebaseUserUtil - Found \(followers.count) followers for user: \(username)")
            completion(followers)
        }
    }
    
    // Function to get who a User is following.
    func getFollowing(username: String, completion: @escaping ([String]) -> Void) {
        let followingRef = database.collection("users").document(username).collection("following")
        
        followingRef.getDocuments { snapshot, error in
            if let error = error {
                print("FirebaseUserUtil - Error fetching following: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("FirebaseUserUtil - No following found for user: \(username)")
                completion([])
                return
            }
            
            let following = documents.map { $0.documentID }
            
            print("FirebaseUserUtil - Found \(following.count) followers for user: \(username)")
            completion(following)
        }
    }
    
    // Retrieves all of the User Information in Firebase and Returns it as a Profile Struct.
    func getProfileInformation(username: String, completion: @escaping (Profile?) -> Void) {
        let database = Firestore.firestore()
        let userRef = database.collection("users").document(username)
        
        // Fetch user document
        userRef.getDocument { document, error in
            if error == nil {
                print("FirebaseUserUtil - Successful Retrieval of User Document")
                
                if let data = document?.data() {
                    let email = data["email"] as? String
                    let username = data["username"] as? String
                    
                    // Retrieve followers and following
                    self.getFollowers(username: username!, completion: { followers in
                        self.getFollowing(username: username!, completion: { following in
                            
                            // Retrieve profile photo info
                            if let photoURLString = data["photoURL"] as? String,
                               let photoURL = URL(string: photoURLString) {
                                
                                let user = User(username: username!, email: email!, photoURL: photoURL)
                                let profile = Profile(user: user, followers: followers, following: following)
                                
                                print("FirebaseUserUtil - Profile Successfully Created")
                                completion(profile)
                                
                            } else {
                                
                                print("FirebaseUserUtil - UnSuccessful Profile ImageRef Retrieval")
                                
                                let user = User(username: username!, email: email!, photoURL: nil)
                                let profile = Profile(user: user, followers: followers, following: following)
                                
                                completion(profile)
                            }
                        })
                    })
                } else {
                    print("FirebaseUserUtil - Error in User Document: \(String(describing: document))")
                    print("") // spacer in logs
                    completion(nil)
                    return
                }
            } else {
                print("FirebaseUserUtil - Error Fetching User Document: \(error!.localizedDescription)")
                print("") // spacer in logs
                completion(nil)
                return
            }
        }
    }
}

struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var photoURL: URL?
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.photoURL = nil
    }
    
    init(username: String, email: String, photoURL: URL?) {
        self.username = username
        self.email = email
        self.photoURL = photoURL
    }
}

// A remnant of old code, this can be combined with User now
struct Profile {
    var user: User
    var followers: [String]
    var following: [String]
    
    init(user: User, followers: [String], following: [String]) {
        self.user = user
        self.followers = followers
        self.following = following
    }
}

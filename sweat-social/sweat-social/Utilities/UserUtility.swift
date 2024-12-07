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
    
    // Function for adding a follower to a target user based on usernames.
    func addFollowerToTarget(targetUsername: String, followerUsername: String) {
        let targetRef = database.collection("users").document(targetUsername)
        let followerRef = database.collection("users").document(followerUsername)
        
        print("RegisterFirebaseManager - \(followerUsername) set to Follow \(targetUsername)")
        
        targetRef.collection("followers").document(targetUsername).setData([
            "reference": followerRef
        ]) { error in
            if let error = error {
                print("RegisterFirebaseManager -    Error adding follower: \(error.localizedDescription)")
            } else {
                print("RegisterFirebaseManager -    Follower added successfully.")
            }
        }
    }
    
    // Function for removing a follower from a target user based on usernames.
    func removeFollowerFromTarget(targetUsername: String, followerUsername: String) {
        let targetRef = database.collection("users").document(targetUsername)
        let followerRef = database.collection("users").document(followerUsername)
        
        print("RegisterFirebaseManager - \(followerUsername) set to UnFollow \(targetUsername)")
        
        // Remove the follower from the target user's Followers collection
        targetRef.collection("followers").document(followerUsername).delete { error in
            if error == nil {
                print("RegisterFirebaseManager -    follower removed successfully")
                
                // Remove the target user from the follower's Following collection
                followerRef.collection("following").document(targetUsername).delete { error in
                    if error == nil {
                        print("RegisterFirebaseManager -    target removed successfully")
                    } else {
                        print("RegisterFirebaseManager -    Error removing target from follower: \(error!.localizedDescription)")
                    }
                }
            } else {
                print("RegisterFirebaseManager -    Error removing follower from target: \(error!.localizedDescription)")
            }
        }
    }
    
    // Function to get a User's followers.
    func getFollowers(username: String) {
        let userRef = database.collection("users").document(username)
        
        userRef.collection("followers").getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving followers: \(error.localizedDescription)")
            } else {
                for document in snapshot?.documents ?? [] {
                    if let ref = document.get("reference") as? DocumentReference {
                        ref.getDocument { userDoc, error in
                            if let userDoc = userDoc, userDoc.exists {
                                print("Follower: \(userDoc.data() ?? [:])")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Function to get who a User is following.
    func getFollowing(username: String) {
        let userRef = database.collection("users").document(username)
        
        userRef.collection("following").getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving following: \(error.localizedDescription)")
            } else {
                for document in snapshot?.documents ?? [] {
                    if let ref = document.get("reference") as? DocumentReference {
                        ref.getDocument { userDoc, error in
                            if let userDoc = userDoc, userDoc.exists {
                                print("Following: \(userDoc.data() ?? [:])")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Retrieves all of the User Information in Firebase and Returns it as a Profile Struct.
    func getProfileInformation(username: String, completion: @escaping (Profile?) -> Void) {
        let storage = Storage.storage()
        let database = Firestore.firestore()
        let userRef = database.collection("users").document(username)
        
        // Default profile photo
        let defaultPhoto = UIImage(systemName: "person.crop.circle")
        
        // Fetch user document
        userRef.getDocument { document, error in
            if error == nil {
                if let data = document?.data() {
                    print("FirebaseUserUtil - Successful Retrieval of User Document")
                    
                    let email = data["email"] as? String
                    let username = data["username"] as? String
                    
                    // Retrieve followers and following
                    self.fetchSubCollection(userRef: userRef, subCollection: "followers") { followers in
                        self.fetchSubCollection(userRef: userRef, subCollection: "following") { following in
                            
                            // Retrieve profile photo
                            if let photoURLString = data["photoURL"] as? String,
                               let photoURL = URL(string: photoURLString) {
                                
                                ImageUtility().fetchFirebaseImageFromURL(url: photoURL, storage: storage, completion: { image in
                                    if let photo = image {
                                        // Combine into Profile struct
                                        let user = User(username: username!, email: email!, photoURL: photoURL)
                                        let profile = Profile(user: user, photo: photo, followers: followers, following: following)
                                        
                                        print("FirebaseUserUtil - Successful Profile Creation (With Image)")
                                        print("") // spacer in logs
                                        
                                        completion(profile)
                                        
                                    } else {
                                        let user = User(username: username!, email: email!, photoURL: photoURL)
                                        let profile = Profile(user: user, photo: defaultPhoto!, followers: followers, following: following)
                                        
                                        print("FirebaseUserUtil - Photo Ref Exists, but Failed To Be Retrieved!")
                                        print("") // spacer in logs
                                        
                                        completion(profile)
                                    }
                                })
                                
                            } else {
                                // No profile photo, use default
                                let user = User(username: username!, email: email!)
                                let profile = Profile(user: user, photo: defaultPhoto!, followers: followers, following: following)
                                print("FirebaseUserUtil - Successful Profile Creation (No Image)")
                                print("") // spacer in logs
                                completion(profile)
                            }
                        }
                    }
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
    
    private func fetchSubCollection(userRef: DocumentReference, subCollection: String, completion: @escaping ([String]) -> Void) {
        userRef.collection(subCollection).getDocuments { snapshot, error in
            if let error = error {
                print("FirebaseUserUtil - Error fetching \(subCollection): \(error.localizedDescription)")
                print("") // spacer in logs
                completion([])
                return
            }
            
            let ids = snapshot?.documents.map { $0.documentID } ?? []
            completion(ids)
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

struct Profile {
    var user: User
    var profilePhoto: UIImage
    var followers: [String]
    var following: [String]
    
    
    init(user: User, photo: UIImage, followers: [String], following: [String]) {
        self.user = user
        self.profilePhoto = photo
        self.followers = followers
        self.following = following
    }
}

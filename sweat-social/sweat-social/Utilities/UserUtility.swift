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
                                
                                self.fetchImage(url: photoURL, storage: storage) { profilePhoto in
                                    if let photo = profilePhoto {
                                        // Combine into Profile struct
                                        let user = User(username: username!, email: email!, photoURL: photoURL)
                                        let profile = Profile(user: user, photo: photo, followers: followers, following: following)
                                        
                                        print("FirebaseUserUtil - Successful Profile Creation (With Image)")
                                        print("") // spacer in logs
                                        completion(profile)
                                    } else {
                                        print("FirebaseUserUtil - Photo Ref Exists, but Failed To Be Retrieved!")
                                        print("")
                                        completion(nil)
                                    }
                                }
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

    private func fetchImage(url: URL, storage: Storage, completion: @escaping (UIImage?) -> Void) {
        let path = url.path
        let storageRef = storage.reference(withPath: path)
        
        storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in // maxSize field for image here arbitrarily chosen
            if let error = error {
                print("FirebaseUserUtil - Error downloading image: \(error.localizedDescription)")
                print("") // spacer in logs
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("FirebaseUserUtil - Unable to decode image data while fetching image")
                print("") // spacer in logs
                completion(nil)
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





extension UIImageView {
    // Borrowed from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    
    // Renders an image from the given URL.
    // Helper function for retrieving images inside of Firebase.
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

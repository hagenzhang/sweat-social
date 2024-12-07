//
//  ProfileViewController.swift
//  sweat-social
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    var posts = [Post]()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        loadPosts()
    }
    
    
    // Assigns the ProfileView fields based on the given profile.
    func unpackProfile(receivedPackage: Profile) {
        
        let username = receivedPackage.user.username
        let email = receivedPackage.user.email
        let following = receivedPackage.following
        let followers = receivedPackage.followers
        
        self.profileScreen.avatarImg.loadRemoteImage(from: receivedPackage.user.photoURL)
        
        self.profileScreen.labelName.text = "\(username)"
        self.profileScreen.labelName.font = UIFont.boldSystemFont(ofSize: 24)
        self.profileScreen.labelEmail.text = "email: \(email)"
        self.profileScreen.labelFollowing.text = "Following: \(following.count)"
        self.profileScreen.labelFollowers.text = "Followers: \(followers.count)"
    }
    
    func loadPosts() {
        /*
         let postCol = database.collection("users").document(FirebaseUtil.currentUser!.email!).collection("posts")
         postCol.getDocuments { (snapshot, error) in
         if error == nil {
         for document in snapshot!.documents.reversed() {
         print(document)
         let hours = document.get("hours") as? String
         let mins = document.get("mins") as? String
         let loc = document.get("loc") as? String
         let message = document.get("message") as? String
         let tempImg = (document.get("image") as? [String: Any])!
         
         let temp = Post(hours: hours!,
         mins: mins!,
         loc: loc!,
         message: message!,
         image: ImageMetadata(publicId: (tempImg["publicId"] as? String)!,
         url: (tempImg["url"] as? String)!,
         createdAt: (tempImg["createdAt"] as? Timestamp)!.dateValue()))
         self.posts.append(temp)
         }
         self.profileScreen.tableViewPosts.reloadData()
         }
         }
         */
    }
}

/*
 extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return posts.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "postTable", for: indexPath) as! ProfileViewCell
 fetchImage(from: posts[indexPath.row].image) { image in
 if let image = image {
 cell.labelTime.text = self.posts[indexPath.row].hours + " hours " + self.posts[indexPath.row].mins + " mins"
 cell.labelLocation.text = self.posts[indexPath.row].loc
 cell.cellImg.image = image
 } else {
 print("Failed to fetch the image.")
 }
 }
 return cell
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 let sendPost = Post(hours: posts[indexPath.row].hours,
 mins: posts[indexPath.row].mins,
 loc: posts[indexPath.row].loc,
 message: posts[indexPath.row].message,
 image: posts[indexPath.row].image)
 let dvController = DisplayViewController()
 dvController.receivedPost = sendPost
 self.navigationController?.pushViewController(dvController, animated: true)
 }
 }
 */

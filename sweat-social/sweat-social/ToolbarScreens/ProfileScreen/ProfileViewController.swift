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
        let username:String = (FirebaseUserUtil.currentUser?.displayName)!
        
        print("ProfileViewController - Fetching User's Posts")
        
        FirebasePostUtil().getPostsByUser(username: username) { [weak self] posts in
            guard let self = self else { return }
            self.posts = posts
            print("ProfileViewController - Posts fetched: \(self.posts)")
            
            // Reload your UI
            profileScreen.tableViewPosts.reloadData()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTable", for: indexPath) as! ProfileViewCell
        
        cell.labelTime.text = self.posts[indexPath.row].hours + " hours " + self.posts[indexPath.row].mins + " mins"
        cell.labelLocation.text = self.posts[indexPath.row].loc
        cell.cellImg.loadRemoteImage(from: self.posts[indexPath.row].imageRef)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ProfileViewController - Clicked on a Cell @ indexPath \(indexPath)!")
        
        /*
        let sendPost = Post(hours: posts[indexPath.row].hours,
                            mins: posts[indexPath.row].mins,
                            loc: posts[indexPath.row].loc,
                            message: posts[indexPath.row].message,
                            image: posts[indexPath.row].image)
        let dvController = DisplayViewController()
        dvController.receivedPost = sendPost
        self.navigationController?.pushViewController(dvController, animated: true)
        */
    }
}


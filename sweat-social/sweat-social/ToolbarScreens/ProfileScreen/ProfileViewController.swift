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
    
    var profileViewUser: User!
    
    override func loadView() {
        view = profileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        profileScreen.tableViewPosts.delegate = self
        profileScreen.tableViewPosts.dataSource = self
    }
    
    
    // Assigns the ProfileView fields based on the given profile.
    func unpackProfile(receivedPackage: Profile) {
        
        self.profileViewUser = receivedPackage.user
        
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
        
        loadPosts()
    }
    
    func loadPosts() {
        let username:String = self.profileViewUser.username
        
        self.posts.removeAll()
        
        print("ProfileViewController - Fetching User's Posts")
        
        FirebasePostUtil().getPostsByUser(username: username) { posts in
            print("ProfileViewController - Posts fetched: \(self.posts)")
            // Reload your UI
            self.posts = posts
            self.profileScreen.tableViewPosts.reloadData()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTable", for: indexPath) as! ProfileCellView
        
        cell.labelTime.text = self.posts[indexPath.row].hours + " hours " + self.posts[indexPath.row].mins + " mins"
        cell.labelLocation.text = self.posts[indexPath.row].loc
        cell.cellImg.loadRemoteImage(from: self.posts[indexPath.row].imageRef)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ProfileViewController - Clicked on a Cell @ indexPath \(indexPath)!")
        
        let displayView = DisplayViewController()
        
        displayView.loadPostDetails(post: posts[indexPath.row])
        
        self.navigationController?.pushViewController(displayView, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


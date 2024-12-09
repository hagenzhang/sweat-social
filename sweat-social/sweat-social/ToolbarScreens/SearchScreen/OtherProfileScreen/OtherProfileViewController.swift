//
//  OtherProfileViewController.swift
//  sweat-social
//
//  Created by Christine Lee on 12/8/24.
//

import UIKit
import FirebaseFirestore

class OtherProfileViewController: UIViewController {

    let otherProfileScreen = OtherProfileView()
    var posts = [Post]()
    let database = Firestore.firestore()
    var otherUsername = ""
    
    var profileViewUser: User!
    
    override func loadView() {
        view = otherProfileScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        otherProfileScreen.tableViewPosts.delegate = self
        otherProfileScreen.tableViewPosts.dataSource = self
        
        otherProfileScreen.followButton.addTarget(self, action: #selector(onFollowButtonTapped), for: .touchUpInside)
    }
    
    @objc func onFollowButtonTapped() {
        FirebaseUserUtil().addFollowerToTarget(targetUsername: self.otherUsername, followerUsername: (FirebaseUserUtil.currentUser?.displayName)!)
        
        print("Follow button tapped")
    }
    
    // Assigns the ProfileView fields based on the given profile.
    func unpackProfile(receivedPackage: Profile) {
        
        
        self.profileViewUser = receivedPackage.user
        
        self.otherUsername = receivedPackage.user.username
        let email = receivedPackage.user.email
        let following = receivedPackage.following
        let followers = receivedPackage.followers
        
        self.otherProfileScreen.avatarImg.loadRemoteImage(from: receivedPackage.user.photoURL)
        
        self.otherProfileScreen.labelName.text = "\(self.otherUsername)"
        self.otherProfileScreen.labelName.font = UIFont.boldSystemFont(ofSize: 24)
        self.otherProfileScreen.labelEmail.text = "email: \(email)"
        self.otherProfileScreen.labelFollowing.text = "Following: \(following.count)"
        self.otherProfileScreen.labelFollowers.text = "Followers: \(followers.count)"
        
        FirebaseUserUtil().getFollowing(username: (FirebaseUserUtil.currentUser?.displayName)!, completion: { followings in
            
            for following in followings {
                print("Username " + following.username)
                if (following.username == self.otherUsername) {
                    self.otherProfileScreen.followButton.setTitle("Unfollow", for: .normal)
                    self.otherProfileScreen.followButton.backgroundColor = .systemRed
                }
            }
        })
        
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
            self.otherProfileScreen.tableViewPosts.reloadData()
        }
    }
}

extension OtherProfileViewController: UITableViewDelegate, UITableViewDataSource{
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

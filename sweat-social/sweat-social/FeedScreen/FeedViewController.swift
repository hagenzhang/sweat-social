//
//  FeedViewController.swift
//  sweat-social
//
//  Serves as the "Home Screen" of the app. Displays whichever feed the user has selected.
//  The two feeds are the global feed and the user feed. The user feed is filled with content
//  only from the individuals that the user follows. The global feed is filled with all the
//  content on the platform.
//
//  This screen also contains a toolbar for the following functions:
//  Viewing profile notifications, creating posts, and viewing the profile page
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class FeedViewController: UIViewController {
    let feedView = FeedView()
    var posts = [Post]()
    
    let storage = Storage.storage()
    let database = Firestore.firestore()
    

    override func loadView() {
        view = feedView
        
        globalFeedSelected()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sweat Social"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Log Out",
            style: .plain,
            target: self,
            action: #selector(firebaseLogOut)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .plain,
            target: self,
            action: #selector(toSearchScreen)
        )
        
        let notifs = UIBarButtonItem(image: UIImage(systemName: "app.badge.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self, action: nil)
        let create = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self, action: #selector(createPost))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        ), style: .plain, target: self,  action: #selector(toProfileScreen))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        feedView.tableViewPosts.delegate = self
        feedView.tableViewPosts.dataSource = self
        
        feedView.toolbar.items = [notifs, flexibleSpace, create, flexibleSpace, profile]
        
        feedView.globalFeedButton.addTarget(self, action: #selector(globalFeedSelected), for: .touchUpInside)
        feedView.forYouFeedButton.addTarget(self, action: #selector(forYouFeedSelected), for: .touchUpInside)
    }
    
    @objc func globalFeedSelected() {
        fetchGlobalPosts()
        
        // showing which button is active
        feedView.globalFeedButton.backgroundColor = .lightGray
        feedView.forYouFeedButton.backgroundColor = .clear
    }
    
    @objc func forYouFeedSelected() {
        fetchForYouPosts()
        
        // showing which button is active
        feedView.globalFeedButton.backgroundColor = .clear
        feedView.forYouFeedButton.backgroundColor = .lightGray
    }
    
    
    func fetchGlobalPosts() {
        print("FeedViewController - Fetching Posts for Global Feed")
        
        FirebasePostUtil().getGlobalPosts(completion: { posts in
            self.posts = posts
            
            print("FeedViewController - Post Count: \(posts.count)")
            self.feedView.tableViewPosts.reloadData()
        })
    }
    
    func fetchForYouPosts() {
        print("FeedViewController - Fetching Posts for For You Feed")
        
        FirebasePostUtil().getPostsFromFollowedUsers(username: (FirebaseUserUtil.currentUser?.displayName)!, completion: { posts in
            self.posts = posts
            
            print("FeedViewController - Posts: \(self.posts)")
            self.feedView.tableViewPosts.reloadData()
        })
    }
    
    
    @objc func toProfileScreen() {
        FirebaseUserUtil().getProfileInformation(username: (FirebaseUserUtil.currentUser?.displayName)! , completion: { profile in
            print("FeedViewController - Going to Profile Screen")
            
            if let profile = profile {
                print("FeedViewController - Successful Profile Define: \(profile)")
                
                let profileViewController = ProfileViewController()
                
                // Unpack all of the Profile Info so it renders in the View.
                profileViewController.unpackProfile(receivedPackage: profile)
                
                // Navigate to the ProfileView.
                self.navigationController?.pushViewController(profileViewController, animated: true)
                print("") // spacer in logs
                
            } else {
                print("FeedViewController - Failed to Define Profile!")
            }
            
            
        })
    }
    
    @objc func createPost() {
        print("") // spacer in logs
        let createViewController = CreateViewController()
        self.navigationController?.pushViewController(createViewController, animated: true)
    }
    
    
    @objc func toSearchScreen() {
        // TODO
        print("ToSearchScreen: Not Yet Implemented!")
        print("") // spacer in logs
    }
    
    @objc func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
            print("Sign Out Successful")
            print("") // spacer in logs
            self.navigationController?.popViewController(animated: true)
        }catch{
            print("Couldn't sign out")
            print("") // spacer in logs
        }
    }
}

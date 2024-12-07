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


class FeedViewController: UIViewController {
    let feedView = FeedView()
    var posts = [Post]()
    

    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sweat Social"
        
        FirebaseUserUtil().getProfileInformation(username: FirebaseUserUtil.currentUser!.displayName!, completion: { profile in
            
            let tempPostList = [Post(username: FirebaseUserUtil.currentUser!.displayName!, hours: "1", mins: "30", loc: "home", caption: "temp msg 1",
                                     exercises: "list of exercises", imageRef: profile!.user.photoURL!),
                                Post(username: FirebaseUserUtil.currentUser!.displayName!, hours: "2", mins: "0", loc: "gym 1", caption: "temp msg 2",
                                     exercises: "another list of exercises", imageRef: profile!.user.photoURL!),
                                Post(username: FirebaseUserUtil.currentUser!.displayName!, hours: "1", mins: "0", loc: "gym 2", caption: "temp msg 3",
                                     exercises: "more lists of exercises", imageRef: profile!.user.photoURL!),
                                Post(username: FirebaseUserUtil.currentUser!.displayName!, hours: "1", mins: "30", loc: "gym 3", caption: "temp msg 4",
                                     exercises: "yep, another one here", imageRef: profile!.user.photoURL!),
                                Post(username: FirebaseUserUtil.currentUser!.displayName!, hours: "2", mins: "0", loc: "gym 4", caption: "temp msg 5",
                                     exercises: "worked out real hard", imageRef: profile!.user.photoURL!),
                                Post(username: "admin", hours: "1", mins: "0", loc: "gym 5", caption: "temp msg 6",
                                     exercises: "ran a couple miles or something", imageRef: profile!.user.photoURL!)]
            
            
            self.posts.append(tempPostList[0])
            self.posts.append(tempPostList[1])
            self.posts.append(tempPostList[2])
            self.posts.append(tempPostList[3])
            self.posts.append(tempPostList[4])
            self.posts.append(tempPostList[5])
        })
        
        
        
        // HZ: This seems like a weird place to put the log out, maybe place it in the profile screen instead?
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
    }
    
    @objc func firebaseLogOut() {
        do {
            try Auth.auth().signOut()
            print("Sign Out Successful")
            self.navigationController?.popViewController(animated: true)
        }catch{
            print("Couldn't sign out")
        }
    }
}

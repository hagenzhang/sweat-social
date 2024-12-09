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
    
    let tempPostList = [Post(hours: "1", mins: "30", loc: "home", message: "temp msg 1",
                             exercises: "list of exercises"),
                        Post(hours: "2", mins: "0", loc: "gym 1", message: "temp msg 2",
                             exercises: "another list of exercises"),
                        Post(hours: "1", mins: "0", loc: "gym 2", message: "temp msg 3",
                             exercises: "more lists of exercises"),
                        Post(hours: "1", mins: "30", loc: "gym 3", message: "temp msg 4",
                             exercises: "yep, another one here"),
                        Post(hours: "2", mins: "0", loc: "gym 4", message: "temp msg 5",
                             exercises: "worked out real hard"),
                        Post(hours: "1", mins: "0", loc: "gym 5", message: "temp msg 6",
                             exercises: "ran a couple miles or something")]
    
    override func loadView() {
        view = feedView
        
        posts.append(tempPostList[0])
        posts.append(tempPostList[1])
        posts.append(tempPostList[2])
        posts.append(tempPostList[3])
        posts.append(tempPostList[4])
        posts.append(tempPostList[5])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sweat Social"
        
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
        
<<<<<<< HEAD
        feedView.tableViewPosts.delegate = self
        feedView.tableViewPosts.dataSource = self
        
=======
        feedView.toolbar.items = [notifs, flexibleSpace, create, flexibleSpace, profile]
>>>>>>> 6f0712ae4f6d8c451c437b1a56693007e8875599
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
        // let cvController = CreateViewController()
        // self.navigationController?.pushViewController(cvController, animated: true)
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



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
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    
    var posts = [Post]()
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = feedView
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
        ), style: .plain, target: self,  action: #selector(getProfile))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        feedView.toolbar.items = [notifs, flexibleSpace, create, flexibleSpace, profile]
        
    }
    

    @objc func getProfile() {
        database.collection("users").document(FirebaseUtil.currentUser!.email!).getDocument { (snapshot, error) in
            if error == nil {
                let tempImg = (snapshot!.get("image") as? [String: Any])!
                let sendUser = UserAvatar(
                    name: (snapshot!.get("name") as? String)!,
                    email: (snapshot!.get("email") as? String)!,
                    image: ImageMetadata(publicId: (tempImg["publicId"] as? String)!,
                                         url: (tempImg["url"] as? String)!,
                                         createdAt: (tempImg["createdAt"] as? Timestamp)!.dateValue()))
                    
                // let pvController = ProfileViewController()
                // pvController.receivedPackage = sendUser
                // self.navigationController?.pushViewController(pvController, animated: true)
            }
        }
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



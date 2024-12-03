//
//  FeedViewController.swift
//  sweat-social
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = feedView
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
                    
                let pvController = ProfileViewController()
                pvController.receivedPackage = sendUser
                self.navigationController?.pushViewController(pvController, animated: true)
            }
        }
    }
    
    @objc func createPost() {
        let cvController = CreateViewController()
        self.navigationController?.pushViewController(cvController, animated: true)
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


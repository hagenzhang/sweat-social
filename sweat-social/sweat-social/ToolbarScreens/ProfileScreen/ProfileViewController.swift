//
//  ProfileViewController.swift
//  sweat-social
//

import UIKit
import FirebaseFirestore
/*
class ProfileViewController: UIViewController {

    let profileScreen = ProfileView()
    var posts = [Post]()
    let database = Firestore.firestore()

    override func loadView() {
        view = profileScreen
    }
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "", apiKey: "", apiSecret: ""))

    var receivedPackage: UserAvatar = UserAvatar(
        name: "",
        email: "",
        image: ImageMetadata(publicId: "", url: "", createdAt: Date())
    )
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        let config = CLDConfiguration(cloudName: Keys.cloudName, apiKey: Keys.apiKey)
        self.cloudinary = CLDCloudinary(configuration: config)
        
        unpack()
        
        profileScreen.tableViewPosts.delegate = self
        profileScreen.tableViewPosts.dataSource = self
        
        loadPosts()
    }
    
    func unpack() {
        let unwrappedName = receivedPackage.name
        let unwrappedEmail = receivedPackage.email
        let unwrappedFollowing = receivedPackage.following
        fetchImage(from: receivedPackage.image) { image in
            if let image = image {
                self.profileScreen.avatarImg.image = image
                self.profileScreen.labelName.text = "\(unwrappedName)"
                self.profileScreen.labelName.font = UIFont.boldSystemFont(ofSize: 24)
                self.profileScreen.labelEmail.text = "Email: \(unwrappedEmail)"
                self.profileScreen.labelName.font = UIFont.systemFont(ofSize: 20)
                self.profileScreen.labelFollowing.text = "Following: \(unwrappedFollowing)"
                self.profileScreen.labelFollowing.font = UIFont.systemFont(ofSize: 16)


            } else {
                print("Failed to fetch the image.")
            }
        }
        

    }
    
    func loadPosts() {
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
    }
    
    func fetchImage(from metadata: ImageMetadata, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: metadata.url) else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        
        AF.request(imageUrl).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

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

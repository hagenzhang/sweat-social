//
//  DisplayViewController.swift
//  sweat-social
//

import UIKit

/*
class DisplayViewController: UIViewController {

    let displayView = DisplayView()
    var receivedPost: Post = Post(hours: "",
                                    mins: "",
                                    loc: "",
                                    message: "",
                                    image: ImageMetadata(publicId: "", url: "", createdAt: Date()))

    override func loadView() {
        view = displayView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Post Details"
        
        fetchImage(from: receivedPost.image) { image in
            if let image = image {
                self.displayView.totalTimeValueLabel.text = "\(self.receivedPost.hours) hours \(self.receivedPost.mins) mins"
                self.displayView.locationValueLabel.text = self.receivedPost.loc
                self.displayView.messageValueLabel.text = self.receivedPost.message
                self.displayView.avatarImg.image = image
            } else {
                print("Failed to fetch the image.")
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
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Failed to decode image data.")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

}
*/

//
//  DisplayViewController.swift
//  sweat-social
//
//  Created by Ian Kim on 12/1/24.
//

import UIKit


class DisplayViewController: UIViewController {

    let displayView = DisplayView()
    var receivedPost: Posts = Posts(hours: "", 
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
            DispatchQueue.main.async {
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
    }
    
    func fetchImage(from metadata: ImageMetadata, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: metadata.url) else {
            print("Invalid URL.")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image data.")
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }

}

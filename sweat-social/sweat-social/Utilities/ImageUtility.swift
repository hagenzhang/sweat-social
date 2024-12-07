//
//  ImageUtility.swift
//  sweat-social
//
//  Created by Hagen Zhang on 12/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ImageUtility {
    let storage = Storage.storage()
    let database = Firestore.firestore()
    
    func fetchFirebaseImageFromURL(url: URL, storage: Storage, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        print("ImageUtility - Successfully Fetched Image from URL: \(url)")
                        completion(image)
                    }
                }
            } else {
                print("ImageUtility - Unable to Fetch Image from URL")
                completion(nil)
            }
        }
    }
}

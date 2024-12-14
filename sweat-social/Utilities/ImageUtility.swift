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

extension UIImageView {
    //MARK: Borrowed from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
    func loadRemoteImage(from url: URL?) {
        if let url = url {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.image = UIImage(systemName: "person.fill")
                        }
                    }
                }
            }
        } else {
            self.image = UIImage(systemName: "person.fill")
        }
        
    }
}

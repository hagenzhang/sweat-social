//
//  CreateFirebaseController.swift
//  sweat-social
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

extension CreateViewController {
    
    // Helper function to instantiate the Post object.
    func developPostStruct(completion: @escaping (Post?) -> Void) {
        
        // ensure the hours field is filled in
        guard var hours = createView.hoursTextField.text, !hours.isEmpty else {
            let alert = UIAlertController(title: "Text Error", message: "Please enter hours.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // ensure the min field is filled in
        guard var mins = createView.minutesTextField.text, !mins.isEmpty else {
            let alert = UIAlertController(title: "Text Error", message: "Please enter minutes.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // ensure minutes and hours are properly formatted
        if Int(mins)! > 59 {
            var tempMins = Int(mins)!
            var tempHours = Int(hours)!
            
            tempHours += Int(floor(Double(tempMins) / 60.0))
            tempMins = (tempMins % 60)
            
            hours = String(tempHours)
            mins = String(tempMins)
        }
        
        let location = createView.locationTextField.text ?? ""
        let details = createView.createView.text ?? ""
        let caption = createView.captionTextField.text ?? ""
        
        // Attempt to upload the image into Firebase
        // ensure a photo is selected
        if let image = pickedImage {
            if let jpegData = image.jpegData(compressionQuality: 100) {
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("postPictures") // storage path for profile photos
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                _ = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil {
                        print("CreateFirebaseManager - Success on uploadTask")
                        
                        imageRef.downloadURL(completion: { url, error  in
                            if error == nil {
                                print("CreateFirebaseManager -     url = \(url!)")
                                
                                let post = Post(username: FirebaseUserUtil.currentUser!.displayName!,
                                                hours: hours,
                                                mins: mins,
                                                loc: location,
                                                caption: caption,
                                                exercises: details,
                                                imageRef: url!,
                                                likes: []) // all posts start with 0 likes
                                completion(post)
                            } else {
                                print("CreateFirebaseManager -    Error Getting downloadURL")
                                
                            }
                        })
                    } else {
                        print("CreateFirebaseManager - uploadTask Failed!")
                        print("CreateFirebaseManager -    Error: \(String(describing: error))")
                        completion(nil)
                    }
                })
            }
        
        // No image selected, return nil
        } else {
            let alert = UIAlertController(title: "Image Error", message: "Please select an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completion(nil)
        }
    }
}

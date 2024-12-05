//
//  RegisterFirebaseManager.swift
//  sweat-social
//
//  RegisterView extension for saving the new user in Firebase.
//  New users will need to be added in both Firebase Authentication and Firestore.
//


import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

extension RegisterViewController {
    
    func registerUser() {
        var profilePhotoURL:URL?
        
        // Check the text fields to ensure that the inputs are valid.
        if !areInputsValid() {
            return
        }
        
        // Upload the profile photo if there is any. Having a photo is optional.
        if let image = pickedImage {
            print("RegisterFirebaseManager - pickedImage is not nil")
            
            if let jpegData = image.jpegData(compressionQuality: 80) {
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("profilePictures")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                _ = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil {
                        imageRef.downloadURL(completion: { (url, error) in
                            if error == nil {
                                profilePhotoURL = url
                            }
                        })
                    }
                })
            }
        }
        
        // Creating the User based on the text fields.
        if let name = registerView.textFieldUsername.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                if error == nil {
                    // if no error, set user info in Firebase Auth (with link to Photo!)
                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: profilePhotoURL)
                }
            })
        }
    }
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        print("RegisterFirebaseManager - PhotoURL = \(String(describing: photoURL))")
        
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("RegisterFirebaseManager - Error occured: \(String(describing: error))")
            } else {
                self.saveUserToFireStore(user: <#T##User#>)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func saveUserToFireStore(user: User){
        let collectionUser = database.collection("users").document(user.email)
        
        do {
            try collectionUser.setData(from: user, completion: {(error) in
                if error == nil {
                    print("Added user to firestore")
                }
            })
        } catch {
            print("Error adding document!")
        }
    }
    
    
    func areInputsValid() -> Bool {
        if registerView.textFieldUsername.text == "" {
            let alert = UIAlertController(title: "Username Error", message: "Enter a username.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if !isValidEmail(registerView.textFieldEmail.text!) {
            let alert = UIAlertController(title: "Email Error", message: "Email must be valid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if registerView.textFieldPassword.text == "" {
            let alert = UIAlertController(title: "Password Error", message: "Enter a password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if registerView.textFieldPassword.text! != registerView.textFieldConfirm.text! {
            let alert = UIAlertController(title: "Password Error", message: "The two passwords must match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    

}

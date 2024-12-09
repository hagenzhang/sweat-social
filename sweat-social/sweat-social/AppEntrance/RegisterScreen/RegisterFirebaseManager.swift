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
import FirebaseFirestore
import UIKit

extension RegisterViewController {
    
    // This function will set off a long chain of function calls, due to how the completion closure works.
    func registerUser() {
        // Check the text fields to ensure that the inputs are valid.
        if !areInputsValid() {
            return
        }
        
        // Upload the profile photo if there is any. Having a photo is optional.
        if let image = pickedImage {
            print("RegisterFirebaseManager - Photo Selected, pickedImage is NOT NIL")
            
            if let jpegData = image.jpegData(compressionQuality: 80) {
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("profilePictures") // storage path for profile photos
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                _ = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil {
                        imageRef.downloadURL(completion: { (url, error) in
                            if error == nil {
                                print("RegisterFirebaseManager - Success on uploadTask")
                                print("RegisterFirebaseManager -     url = \(url!)")
                                self.addUserToFirebaseAuth(name: self.registerView.textFieldUsername.text!,
                                                           email: self.registerView.textFieldEmail.text!,
                                                           pass: self.registerView.textFieldPassword.text!,
                                                           photoRef: url!)
                            }
                        })
                    } else {
                        print("RegisterFirebaseManager - uploadTask Failed!")
                        print("RegisterFirebaseManager - Error: \(String(describing: error))")
                    }
                })
            }
        } else {
            print("RegisterFirebaseManager - No Photo Selected, using NIL")
            self.addUserToFirebaseAuth(name: self.registerView.textFieldUsername.text!,
                                       email: self.registerView.textFieldEmail.text!,
                                       pass: self.registerView.textFieldPassword.text!,
                                       photoRef: nil)
        }
    }
    
    
    // Uses the given information to create an initial user in Firebase Authentication.
    func addUserToFirebaseAuth(name: String, email: String, pass: String, photoRef: URL?) {
        Auth.auth().createUser(withEmail: email, password: pass, completion: { result, error in
            if error == nil {
                // if no error, set user info in Firebase Auth (with link to Photo!)
                print("RegisterFirebaseManager - User successfully created in Firebase Authentication")
                self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoRef)
                
            } else {
                print("RegisterFirebaseManager - User Failed to be created in Firebase Authentication!")
                print("RegisterFirebaseManager - Error: \(String(describing: error))")
                
                // error handling
                if let authError = error as NSError?, authError.domain == AuthErrorDomain {
                    if authError.userInfo[AuthErrorUserInfoNameKey] as? String == "ERROR_WEAK_PASSWORD" {
                        let alert = UIAlertController(title: "Password Error", message: "Password should be at least 6 characters.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if authError.userInfo[AuthErrorUserInfoNameKey] as? String == "ERROR_EMAIL_ALREADY_IN_USE" {
                        let alert = UIAlertController(title: "Email Error", message: "The email address is already in use by another account.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    
    // Adds Name and Photo parameters to the User in Firebase Authentication.
    // This function gives our new User a username and a profile photo reference from Firebase Storage
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        // Only add the photo Ref in if there is one,
        if let photo = photoURL {
            changeRequest?.photoURL = photo
        } else {
            changeRequest?.photoURL = URL(string: "")
        }
        
        print("RegisterFirebaseManager - PhotoURL to update in Firebase Auth = \(String(describing: photoURL))")
        
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("RegisterFirebaseManager - Error occured with User Auth Change: \(String(describing: error))")
            } else {
                print("RegisterFirebaseManager - User Auth Change Successful")
                
                let newUser = User(username: name, email: email, photoURL: photoURL)
                
                self.saveUserToFireStore(user: newUser)
            }
        })
    }
    
    func saveUserToFireStore(user: User){
        let collectionUser = database.collection("users").document(user.username)
        
        do {
            try collectionUser.setData(from: user, completion: {(error) in
                if error == nil {
                    print("RegisterFirebaseManager - Adding User to Firestore Successful")
                    
                    self.navigationController?.popViewController(animated: true)
                    print("") // spacer in logs
                    
                } else {
                    print("RegisterFirebaseManager - Error Adding User to Firestore!")
                    print("RegisterFirebaseManager -    \(String(describing: error))")
                }
            })
        } catch {
            print("RegisterFirebaseManager - EXCEPTION Adding User to Firestore!")
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

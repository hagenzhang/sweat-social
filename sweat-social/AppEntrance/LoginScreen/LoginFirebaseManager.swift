//
//  LoginFirebaseManager.swift
//  sweat-social
//
//  ViewController extension with a function to handle login attempts.
//

import Foundation
import UIKit
import FirebaseAuth

extension ViewController {
    
    func firebaseLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                print("LoginFirebaseManager - Log In Successful!")
                
            } else {
                let alert = UIAlertController(title: "Login Error", message: "Email and Password combination is invalid.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)            }
        })
    }
}

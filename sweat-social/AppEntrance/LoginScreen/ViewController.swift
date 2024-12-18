//
//  ViewController.swift
//  sweat-social
//
//  Handles the Login process. Contains the state change listener for logging in/out.
//  Sends users to the FeedView on successful login. Users can also go to the RegisterScreen
//  to create a new account in firebase.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    let loginView = LogInView()
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sweat Social"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        loginView.registerButton.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
        
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                print("ViewController - Logged Out State Change")
                FirebaseUserUtil.currentUser = nil
                
            } else {
                print("ViewController - Logged In State Change")
                FirebaseUserUtil.currentUser = user
                
                self.toMainScreen()
                
                self.loginView.emailField.text = ""
                self.loginView.passwordField.text = ""
            }
        }
    }
    
    @objc func loginButtonPress() {
        let email = loginView.emailField.text
        let password = loginView.passwordField.text
        
        if email!.isEmpty || password!.isEmpty {
            let alert = UIAlertController(title: "Login Error", message: "Please provide an email and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        firebaseLogin(email: email!, password: password!)
    }
    
    @objc func registerButtonPress() {
        let registerView = RegisterViewController()
        navigationController?.pushViewController(registerView, animated: true)
    }

    func toMainScreen() {
        let feedView = FeedViewController()
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.pushViewController(feedView, animated: true)
        print("") // spacer in logs
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
}




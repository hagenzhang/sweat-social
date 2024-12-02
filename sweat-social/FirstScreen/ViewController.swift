import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    let loginView = LogInView()
    
    let firebaseUtil = FirebaseUtil()
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
                print("Logged Out State Change")
                FirebaseUtil.currentUser = nil
                
            } else {
                print("Logged In State Change")
                FirebaseUtil.currentUser = user
                self.toMainScreen()
                
                self.loginView.emailField.text = ""
                self.loginView.passwordField.text = ""
            }
        }
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
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
        
        firebaseLogIn(email: email!, password: password!)
    }
    
    @objc func registerButtonPress() {
        let registerView = RegisterViewController()
        navigationController?.pushViewController(registerView, animated: true)
    }

    func toMainScreen() {
        let mainView = MainViewController()
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.pushViewController(mainView, animated: true)
    }
    
}



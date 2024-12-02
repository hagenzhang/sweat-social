import UIKit

class LogInView: UIView {
    
    var emailField: UITextField!
    var passwordField: UITextField!
    var loginButton: UIButton!
    var askingText: UILabel!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupAskingText()
        setupRegisterButton()
        
        initConstraints()
    }
    
    func setupEmailField() {
        emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.borderStyle = .roundedRect
        emailField.placeholder = "Email"
        emailField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailField)
    }
    
    func setupPasswordField() {
        passwordField = UITextField()
        passwordField.borderStyle = .roundedRect
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordField)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .roundedRect)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 25
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
    }
    
    func setupAskingText() {
        askingText = UILabel()
        askingText.text = "Don't have an account?"
        askingText.font = UIFont.systemFont(ofSize: 16)
        askingText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(askingText)
    }
    
    func setupRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Create Account", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            emailField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            emailField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            emailField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            passwordField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            passwordField.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            askingText.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            askingText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            registerButton.topAnchor.constraint(equalTo: askingText.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            registerButton.widthAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.widthAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

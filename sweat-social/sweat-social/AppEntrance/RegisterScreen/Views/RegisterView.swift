//
//  RegisterView.swift
//  sweat-social
//

import UIKit

class RegisterView: UIView {
    var selectPic: UIButton!
    
    var textFieldUsername: UITextField!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldConfirm: UITextField!
    
    var buttonRegister: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSelectPic()
        setuptextFieldUsername()
        setuptextFieldEmail()
        setuptextFieldPassword()
        setuptextFieldConfirm()
        setupbuttonRegister()
        
        initConstraints()
    }
    
    func setupSelectPic(){
        selectPic = UIButton(type: .system)
        selectPic.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        selectPic.contentHorizontalAlignment = .fill
        selectPic.contentVerticalAlignment = .fill
        selectPic.imageView?.contentMode = .scaleAspectFit
        selectPic.showsMenuAsPrimaryAction = true
        selectPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectPic)
    }
    
    func setuptextFieldUsername(){
        textFieldUsername = UITextField()
        textFieldUsername.placeholder = "Username"
        textFieldUsername.keyboardType = .default
        textFieldUsername.borderStyle = .roundedRect
        textFieldUsername.autocorrectionType = .no
        textFieldUsername.autocapitalizationType = .none
        textFieldUsername.spellCheckingType = .no
        textFieldUsername.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldUsername)
    }
    
    func setuptextFieldEmail(){
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.spellCheckingType = .no
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    func setuptextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    func setuptextFieldConfirm(){
        textFieldConfirm = UITextField()
        textFieldConfirm.placeholder = "Confirm Password"
        textFieldConfirm.isSecureTextEntry = true
        textFieldConfirm.borderStyle = .roundedRect
        textFieldConfirm.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldConfirm)
    }
    
    func setupbuttonRegister(){
        buttonRegister = UIButton(type: .system)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonRegister)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            selectPic.topAnchor.constraint(equalTo:self.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectPic.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            selectPic.widthAnchor.constraint(equalToConstant: 100),
            selectPic.heightAnchor.constraint(equalToConstant: 100),
            
            textFieldUsername.topAnchor.constraint(equalTo: selectPic.bottomAnchor, constant: 32),
            textFieldUsername.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldUsername.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textFieldUsername.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            textFieldUsername.heightAnchor.constraint(equalToConstant: 32),
            
            textFieldEmail.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 16),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            textFieldConfirm.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
            textFieldConfirm.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            textFieldConfirm.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textFieldConfirm.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            buttonRegister.topAnchor.constraint(equalTo: textFieldConfirm.bottomAnchor, constant: 32),
            buttonRegister.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

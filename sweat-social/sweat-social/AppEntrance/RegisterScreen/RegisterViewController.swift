//
//  RegisterViewController.swift
//  sweat-social
//
//  Screen for registering a new account in firebase. Each account must be registered with the following:
//  first name, last name, email, and password. A profile photo is optional, and if not provided, one
//  will be given by default.
//
//  Once an account has been successfully registered, the user will automatically be logged in and
//  navigate to the FeedScreen.
//

import FirebaseStorage
import FirebaseFirestore
import PhotosUI

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    let storage = Storage.storage()
    let database = Firestore.firestore()
    
    var pickedImage:UIImage?

    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

        registerView.selectPic.menu = getMenuImagePicker()
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
    }
    

    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    @objc func onRegisterTapped() {
        registerUser()
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }

}

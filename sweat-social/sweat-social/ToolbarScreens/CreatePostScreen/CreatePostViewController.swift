//
//  CreatePostViewController.swift
//  sweat-social
//

import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class CreateViewController: UIViewController {
    
    let storage = Storage.storage()
    let database = Firestore.firestore()
    
    let createView = CreateView()
    var pickedImage:UIImage?
    
    override func loadView() {
        view = createView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Create Post"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(savePost)
        )
        
        createView.selectPic.menu = getMenuImagePicker()
    }
    
    @objc func savePost() {
        developPostStruct(completion: { post in
            if let post = post {
                FirebasePostUtil().uploadPost(post: post, completion: { success in
                    if success {
                        print("CreatePostViewController - Post Upload Successful!")
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        print("CreatePostViewController - Post Upload Failed!")
                    }
                })
            } else {
                print("CreatePostViewController - Post is NIL, could not save!")
            }
        })
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
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
}

extension CreateViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.createView.selectPic.setImage(
                                uwImage.withRenderingMode(.alwaysOriginal),
                                for: .normal
                            )
                            self.pickedImage = uwImage
                        }
                    }
                })
            }
        }
    }
}

extension CreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.createView.selectPic.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            // Do your thing for No image loaded...
        }
    }
}

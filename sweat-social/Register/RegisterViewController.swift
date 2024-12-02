import UIKit
import FirebaseAuth
import FirebaseFirestore
import PhotosUI
import Cloudinary

class RegisterViewController: UIViewController {
    
    let database = Firestore.firestore()
    let registerView = RegisterView()
    
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "", apiKey: "", apiSecret: ""))
    
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
        
        let config = CLDConfiguration(cloudName: Keys.cloudName, apiKey: Keys.apiKey)
        self.cloudinary = CLDCloudinary(configuration: config)

        registerView.selectPic.menu = getMenuImagePicker()
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
    }
    
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    @objc func onRegisterTapped(){
        if registerView.textFieldFirstName.text == "" || registerView.textFieldLastName.text == "" {
            let alert = UIAlertController(title: "Name Error", message: "Enter a Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !isValidEmail(registerView.textFieldEmail.text!) {
            let alert = UIAlertController(title: "Email Error", message: "Email must be valid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if registerView.textFieldPassword.text == "" {
            let alert = UIAlertController(title: "Password Error", message: "Enter a password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if registerView.textFieldPassword.text! != registerView.textFieldConfirm.text! {
            let alert = UIAlertController(title: "Password Error", message: "The two passwords must match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            registerNewAccount()
        }
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
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}


extension RegisterViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
                            self.registerView.selectPic.setImage(
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
extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.registerView.selectPic.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            // Do your thing for No image loaded...
        }
    }
}

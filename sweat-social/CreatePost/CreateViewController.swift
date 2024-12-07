import UIKit
import PhotosUI
import FirebaseFirestore
import Cloudinary

class CreateViewController: UIViewController {

    let createView = CreateView()
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "", apiKey: "", apiSecret: ""))
    var pickedImage:UIImage?
    
    override func loadView() {
        view = createView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Create Post"
        
        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(saveNoteTapped)
        )

        let config = CLDConfiguration(cloudName: Keys.cloudName, apiKey: Keys.apiKey)
        self.cloudinary = CLDCloudinary(configuration: config)
        
        createView.selectPic.menu = getMenuImagePicker()
    }
    
    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap(){
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }

    @objc func saveNoteTapped() {
        guard var hours = createView.hoursTextField.text, !hours.isEmpty else {
            let alert = UIAlertController(title: "Text Error", message: "Please enter hours.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard var mins = createView.minutesTextField.text, !mins.isEmpty else {
            let alert = UIAlertController(title: "Text Error", message: "Please enter minutes.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if Int(mins)! > 59 {
            var tempMins = Int(mins)!
            var tempHours = Int(hours)!
            
            tempHours += Int(floor(Double(tempMins) / 60.0))
            tempMins = (tempMins % 60)
            
            hours = String(tempHours)
            mins = String(tempMins)
        }
        
        var loc = (createView.locationTextField.text)!
        if loc.isEmpty {
            loc = ""
        }
        
        var details = (createView.createView.text)!
        if details.isEmpty || details == "Enter details here (Optional)"{
            details = ""
        }
        
        let curDT = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        var imageData = Data()

        if pickedImage != nil {
            imageData = pickedImage!.jpegData(compressionQuality: 0.9)!
        } else {
            imageData =  UIImage(systemName: "photo.fill")!.jpegData(compressionQuality: 0.9)!
        }
        pickedImage = nil
        
        self.cloudinary.createUploader().upload(data: imageData, uploadPreset: "fsreydnl", completionHandler:  { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                print("Error details: \(error.userInfo)")
                print(imageData)
                
            } else if let result = result {
                let publicId = result.publicId
                let secureUrl = result.secureUrl
                let createdAt = Date()
                let metaData = ImageMetadata(publicId: publicId!, url: secureUrl!, createdAt: createdAt)
                
                let postCollection = Firestore.firestore().collection("users").document(FirebaseUtil.currentUser!.email!).collection("posts").document(curDT.description)
                do {
                    let tempPost = Post(hours: hours, mins: mins, loc: loc, message: details, image: metaData)
                    try postCollection.setData(from: tempPost, completion: {(error) in
                        if error == nil {
                            print("Added post to firestore")
                        }
                    })
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    print("Error adding post!")
                }
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

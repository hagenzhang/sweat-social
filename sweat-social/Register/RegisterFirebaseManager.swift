import Foundation
import FirebaseAuth
import FirebaseFirestore
import Cloudinary
import PhotosUI

extension RegisterViewController {
    
    func registerNewAccount() {
        if let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            
            let name = registerView.textFieldFirstName.text! + " " + registerView.textFieldLastName.text!
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    let user = User(name: name, email: email)
                    self.saveUserToFireStore(user: user)
                    
                } else {
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
                    print(error!)
                }
            })
        }
    }
    
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                // profile update successful
                // self.hideActivityIndicator()
                
            } else {
                print("Error occured: \(String(describing: error))")
            }
        })
    }

    func saveUserToFireStore(user: User){
        var imageData = Data()

        if pickedImage != nil {
            imageData = pickedImage!.jpegData(compressionQuality: 0.9)!
        } else {
            imageData =  UIImage(systemName: "person.fill")!.jpegData(compressionQuality: 0.9)!
        }
        pickedImage = nil
        
        self.cloudinary.createUploader().upload(data: imageData, uploadPreset: "fsreydnl", completionHandler:  { result, error in
            if let error = error as? NSError {
                print("Error: \(error.localizedDescription)")
                print("Error details: \(error.userInfo)")
                print(imageData)
                
            } else if let result = result {
                let publicId = result.publicId
                let secureUrl = result.secureUrl
                let createdAt = Date()
                let metaData = ImageMetadata(publicId: publicId!, url: secureUrl!, createdAt: createdAt)
                
                let collectionUser = self.database.collection("users").document(user.email)
                do {
                    let userImg = UserAvatar(name: user.name, email: user.email, image: metaData)
                    try collectionUser.setData(from: userImg, completion: {(error) in
                        if error == nil {
                            print("Added user to firestore")
                        }
                    })
                } catch {
                    print("Error adding document!")
                }
            }
        })
    }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

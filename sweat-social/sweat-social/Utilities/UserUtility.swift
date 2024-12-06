//
//  UserUtils.swift
//  sweat-social
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseUtil {
    static var currentUser: FirebaseAuth.User?
}

struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var photoURL: URL?
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.photoURL = nil
    }
    
    init(username: String, email: String, photoURL: URL?) {
        self.username = username
        self.email = email
        self.photoURL = photoURL
    }
}

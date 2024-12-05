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

struct ImageMetadata: Codable {
    var publicId: String
    var url: String
    var createdAt: Date
    
    init(publicId: String, url: String, createdAt: Date) {
        self.publicId = publicId
        self.url = url
        self.createdAt = createdAt
    }
}

struct User: Codable{
    @DocumentID var id: String?
    var username: String
    var email: String
    var photoRef: String?
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.photoRef = nil
    }
    
    init(username: String, email: String, photoRef: String) {
        self.username = username
        self.email = email
        self.photoRef = photoRef
    }
}

struct UserAvatar: Codable{
    @DocumentID var id: String?
    var name: String
    var email: String
    var image: ImageMetadata
    var following: Int
    
    init(name: String, email: String, image: ImageMetadata, following: Int = 0) {
        self.name = name
        self.email = email
        self.image = image
        self.following = following
    }
}


class Configs{
    static let tableViewTextsID = "tableViewTextsID"
}

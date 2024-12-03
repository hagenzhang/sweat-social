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
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
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


struct Post: Codable {
    var hours: String
    var mins: String
    var loc: String
    var message: String
    var image: ImageMetadata?
    
    init(hours: String, mins: String, loc: String, message: String) {
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.message = message
        self.image = nil
    }
    
    init(hours: String, mins: String, loc: String, message: String, image: ImageMetadata) {
        self.hours = hours
        self.mins = mins
        self.loc = loc
        self.message = message
        self.image = image
    }
}

class Configs{
    static let tableViewTextsID = "tableViewTextsID"
}

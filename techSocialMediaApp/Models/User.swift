//
//  User.swift
//  techSocialMediaApp
//
//  Created by Brayden Lemke on 10/25/22.
//

import Foundation

struct User: Decodable, Encodable {
    var firstName: String
    var lastName: String
    var email: String
    var userUUID: UUID
    var secret: UUID
    var userName: String
    
    static var current: User?
}

struct UserProfile: Codable {
    
    var firstName: String
    var lastName: String
    var userName: String
    var userUUID: UUID
    var bio: String?
    var techInterests: String?
    var posts: [Post]?

}

struct Post: Codable {
    
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var authorUserId: UUID
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
    
}

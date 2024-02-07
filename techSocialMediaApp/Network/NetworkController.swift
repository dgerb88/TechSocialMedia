//
//  NetworkController.swift
//  techSocialMediaApp
//
//  Created by Dax Gerber on 2/6/24.
//

import Foundation

class NetworkController {
    
    static var shared = NetworkController()
    
    enum NetworkError: Error, LocalizedError {
        case couldNotGetUserProfile
        case couldNotPostUpdateToProfile
        case couldNotGetPosts
        case couldNotCreatePost
        case couldNotGetComments
        case couldNotCreateComment
        case couldNotUpdateLikes
        case couldNotGetUserPosts
        case couldNotDeletePost
        case couldNotEditPost
    }
    
    func getUserProfile(userUUID: UUID, userSecret: UUID) async throws -> UserProfile {
        
        let session = URLSession.shared
        let url = "\(API.url)/userProfile"
        var urlComponents = URLComponents(string: url)
        let query = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "userUUID", value: userUUID.uuidString)
        ]
        urlComponents?.queryItems = query
        var request = URLRequest(url: URL(string: urlComponents!.url!.absoluteString)!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotGetUserProfile
        }
        
        let decoder = JSONDecoder()
        let userProfile = try decoder.decode(UserProfile.self, from: data)
        return userProfile
    }
    
    func updateProfile(userSecret: UUID, updatedProfile: UserProfile) async throws -> UserProfile {
        // Initialize our session and request
        
        let profileDict: [String: Any] = [
            "userName": updatedProfile.userName,
            "bio": updatedProfile.bio ?? "",
            "techInterests": updatedProfile.techInterests ?? ""
        ]
        let credentials: [String: Any] = ["userSecret": userSecret.uuidString, "profile": profileDict]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/updateProfile")!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotPostUpdateToProfile
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let updatedProfile = try decoder.decode(UserProfile.self, from: data)
        return updatedProfile
    }
    
    
    
    
    
    
    
    
    
}

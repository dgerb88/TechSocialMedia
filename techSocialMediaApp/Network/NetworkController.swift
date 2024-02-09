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
    
    func getPosts(userSecret: UUID, pageNumber: Int?) async throws -> [Post] {
        let baseUrl = "\(API.url)/posts"
        let session = URLSession.shared
        var urlComponents = URLComponents(string: baseUrl)
        let query = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "pageNumber", value: String(pageNumber ?? 0))
        ]
        urlComponents?.queryItems = query
        var request = URLRequest(url: URL(string: urlComponents!.url!.absoluteString)!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotGetPosts
        }
        
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        return posts
    }
    
    func createPost(userSecret: UUID, title: String, body: String) async throws -> Post {
        let postDict: [String: Any] = [
            "title": title,
            "body": body,
        ]
        let credentials: [String: Any] = ["userSecret": userSecret.uuidString, "post": postDict]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createPost")!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotCreatePost
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let newPost = try decoder.decode(Post.self, from: data)
        return newPost
    }
    
    func getComments(userSecret: UUID, postid: Int, pageNumber: Int?) async throws -> [Comment] {
        
        let baseUrl = "\(API.url)/comments"
        let session = URLSession.shared
        var urlComponents = URLComponents(string: baseUrl)
        let query = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "postid", value: String(postid)),
            URLQueryItem(name: "pageNumber", value: String(pageNumber ?? 0))
        ]
        urlComponents?.queryItems = query
        var request = URLRequest(url: URL(string: urlComponents!.url!.absoluteString)!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotGetComments
        }
        
        let decoder = JSONDecoder()
        let comments = try decoder.decode([Comment].self, from: data)
        return comments
    }
    
    func createComment(userSecret: UUID, commentBody: String, postid: Int) async throws -> Comment {
        
        let credentials: [String: Any] = [
            "userSecret": userSecret.uuidString,
            "commentBody": commentBody,
            "postid": postid
        ]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createComment")!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotCreateComment
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let newComment = try decoder.decode(Comment.self, from: data)
        return newComment
        
    }
    
    func updateLikes(userSecret: UUID, postid: Int) async throws -> Post {
        
        let credentials: [String: Any] = [
            "userSecret": userSecret.uuidString,
            "postid": postid
        ]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/updateLikes")!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotUpdateLikes
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let updatedPost = try decoder.decode(Post.self, from: data)
        return updatedPost
    }
    
    func getUserPosts(userSecret: UUID, userUUID: UUID, pageNumber: Int?) async throws -> [Post] {
        
        let baseUrl = "\(API.url)/userPosts"
        let session = URLSession.shared
        var urlComponents = URLComponents(string: baseUrl)
        let query = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "userUUID", value: userUUID.uuidString),
            URLQueryItem(name: "pageNumber", value: String(pageNumber ?? 0))
        ]
        urlComponents?.queryItems = query
        var request = URLRequest(url: URL(string: urlComponents!.url!.absoluteString)!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotGetUserPosts
        }
        
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        return posts
        
    }
    
    func deletePost(userSecret: UUID, postid: Int) async throws {
        
        let baseUrl = "\(API.url)/post"
        let session = URLSession.shared
        var urlComponents = URLComponents(string: baseUrl)
        let query = [
            URLQueryItem(name: "userSecret", value: userSecret.uuidString),
            URLQueryItem(name: "postid", value: String(postid)),
        ]
        urlComponents?.queryItems = query
        var request = URLRequest(url: URL(string: urlComponents!.url!.absoluteString)!)
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotDeletePost
        }
    }
    
    func editPost(userSecret: UUID, postid: Int, title: String, body: String) async throws -> Post {
        
        let postDict: [String: Any] = [
            "postid": postid,
            "title": title,
            "body": body,
        ]
        let credentials: [String: Any] = ["userSecret": userSecret.uuidString, "post": postDict]
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/editPost")!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.couldNotEditPost
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let newPost = try decoder.decode(Post.self, from: data)
        return newPost
    }
    
}

//
//  UserDetail.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

/// Represents detailed information about a user, including followers and following data.
struct UserDetail: Codable, Equatable {
    /// Unique identifier for the user.
    let id: Int
    /// Login username.
    let login: String
    /// Avatar URL of the user.
    let avatarUrl: String
    /// The landing page URL of the user.
    let htmlUrl: String
    /// The living city/country of the user (optional).
    let location: String?
    /// The number of following users.
    let followers: Int
    /// The number of followed users.
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
}

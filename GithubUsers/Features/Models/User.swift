//
//  User.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

/// Represents a basic User object with essential details.
struct User: Codable, Identifiable, Equatable, Hashable {
    /// Login username.
    let id: Int
    /// Login username.
    let login: String
    /// Avatar URL of the user.
    let avatarUrl: String
    /// The landing page URL of the user.
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

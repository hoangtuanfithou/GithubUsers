//
//  User.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

struct User: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

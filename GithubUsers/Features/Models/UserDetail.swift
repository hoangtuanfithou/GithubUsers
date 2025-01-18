//
//  UserDetail.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

struct UserDetail: Codable, Equatable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int
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

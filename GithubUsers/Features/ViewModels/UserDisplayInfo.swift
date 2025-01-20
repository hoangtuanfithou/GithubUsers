//
//  UserDisplayInfo.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/19.
//

struct UserDisplayInfo {
    let login: String
    let avatarUrl: String
    let location: String?
    let followers: Int
    let following: Int
    let htmlUrl: String
    
    init(from user: User) {
        self.login = user.login
        self.avatarUrl = user.avatarUrl
        self.location = nil
        self.followers = 0
        self.following = 0
        self.htmlUrl = user.htmlUrl
    }
    
    init(from detail: UserDetail) {
        self.login = detail.login
        self.avatarUrl = detail.avatarUrl
        self.location = detail.location
        self.followers = detail.followers
        self.following = detail.following
        self.htmlUrl = detail.htmlUrl
    }
}

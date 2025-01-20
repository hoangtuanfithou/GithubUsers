//
//  PreviewData.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

extension User {
    static let sample = User(
        id: 1,
        login: "mojombo",
        avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
        htmlUrl: "https://github.com/mojombo"
    )
}

extension UserDetail {
    static let sample = UserDetail(
        id: 1,
        login: "mojombo",
        avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
        htmlUrl: "https://github.com/mojombo",
        location: "San Francisco",
        followers: 1000,
        following: 1000
    )
}

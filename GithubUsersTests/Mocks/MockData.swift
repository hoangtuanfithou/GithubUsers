//
//  File.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

@testable import GithubUsers

extension UserDetail {
    static func mock(
        id: Int = 1,
        login: String = "test"
    ) -> UserDetail {
        UserDetail(
            id: id,
            login: login,
            avatarUrl: "",
            htmlUrl: "",
            location: "",
            followers: 1000,
            following: 1000
        )
    }
}

extension User {
    static func mock(
        id: Int = 1,
        login: String = "test"
    ) -> User {
        User(
            id: id,
            login: login,
            avatarUrl: "",
            htmlUrl: ""
        )
    }
}

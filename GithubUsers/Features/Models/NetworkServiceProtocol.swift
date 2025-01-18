//
//  NetworkServiceProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

protocol NetworkServiceProtocol {
    func fetchUsers(since: Int) async throws -> [User]
    func fetchUserDetail(username: String) async throws -> UserDetail
}

//
//  NetworkServiceProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

protocol NetworkServiceProtocol {
    /// Fetches a list of users starting from the given ID.
    /// - Parameter since: The ID to start fetching users from.
    /// - Returns: An array of `User` objects.
    func fetchUsers(since: Int) async throws -> [User]
    
    /// Fetches detailed information about a user by their username.
    /// - Parameter username: The username to fetch details for.
    /// - Returns: A `UserDetail` object.
    func fetchUserDetail(username: String) async throws -> UserDetail
}

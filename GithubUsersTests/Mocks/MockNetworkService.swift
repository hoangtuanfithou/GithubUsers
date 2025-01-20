//
//  MockNetworkService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/19.
//

@testable import GithubUsers

class MockNetworkService: NetworkServiceProtocol {
    
    var users: [User] = []
    var userDetail: UserDetail?
    var error: Error?
    
    func fetchUsers(since id: Int) async throws -> [User] {
        if let error = error {
            throw error
        }
        return users.filter { $0.id > id }
    }
    
    func fetchUserDetail(username: String) async throws -> UserDetail {
        if let error = error {
            throw error
        }
        guard let userDetail = userDetail else {
            throw TestError.missingData
        }
        return userDetail
    }
}

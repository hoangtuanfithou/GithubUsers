//
//  MockStorageService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/19.
//

@testable import GithubUsers

class MockStorageService: StorageServiceProtocol {
    var savedUsers: [User] = []
    var savedUserDetail: UserDetail?
    var cachedUserDetail: UserDetail?
    var error: Error?
    
    func saveUsers(_ users: [User]) throws {
        if let error = error {
            throw error
        }
        savedUsers = users
    }
    
    func getUsers() throws -> [User] {
        if let error = error {
            throw error
        }
        return savedUsers
    }
    
    func saveUserDetail(_ userDetail: UserDetail) throws {
        if let error = error {
            throw error
        }
        savedUserDetail = userDetail
    }
    
    func getUserDetail(forUsername username: String) throws -> UserDetail? {
        if let error = error {
            throw error
        }
        return cachedUserDetail
    }
}


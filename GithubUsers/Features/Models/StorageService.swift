//
//  StorageService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

// Todo: impment caching expiration

final class StorageService: StorageServiceProtocol {
    private let userDefaults: UserDefaultsProtocol
    private let usersKey = "cached_users"
    private let userDetailsPrefix = "user_detail_"
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveUsers(_ users: [User]) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(users)
        userDefaults.set(data, forKey: usersKey)
    }
    
    func getUsers() throws -> [User] {
        guard let data = userDefaults.data(forKey: usersKey) else { return [] }
        let decoder = JSONDecoder()
        return try decoder.decode([User].self, from: data)
    }
    
    func saveUserDetail(_ userDetail: UserDetail) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(userDetail)
        userDefaults.set(data, forKey: userDetailsPrefix + userDetail.login)
    }
    
    func getUserDetail(forUsername username: String) throws -> UserDetail? {
        guard let data = userDefaults.data(forKey: userDetailsPrefix + username) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(UserDetail.self, from: data)
    }
}

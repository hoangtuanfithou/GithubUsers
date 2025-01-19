//
//  StorageService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

final class StorageService: StorageServiceProtocol {
    private let userDefaults: UserDefaultsProtocol
    private let timeProvider: TimeProviderProtocol
    private let usersKey = "cached_users"
    private let userDetailsPrefix = "user_detail_"
    // Cache expiration time in seconds
    private let cacheExpirationInterval: TimeInterval = 60 * 60 * 24 // 1 day
    
    init(
        userDefaults: UserDefaultsProtocol = UserDefaults.standard,
        timeProvider: TimeProviderProtocol = DefaultTimeProvider()
    ) {
        self.userDefaults = userDefaults
        self.timeProvider = timeProvider
    }
        
    // MARK: - Users
    
    func saveUsers(_ users: [User]) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(users)
        
        let cacheObject = CacheObject(data: data, timestamp: timeProvider.now())
        let encodedObject = try encoder.encode(cacheObject)
        userDefaults.set(encodedObject, forKey: usersKey)
    }
        
    func getUsers() throws -> [User] {
        guard let cachedData = userDefaults.data(forKey: usersKey) else {
            return []
        }
        let decoder = JSONDecoder()
        let cacheObject = try decoder.decode(CacheObject.self, from: cachedData)
        
        if cacheObject.timestamp.addingTimeInterval(cacheExpirationInterval) < timeProvider.now() {
            return []
        }
        
        let users = try decoder.decode([User].self, from: cacheObject.data)
        return users
    }
    
    // MARK: - UserDetail
    
    func saveUserDetail(_ userDetail: UserDetail) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(userDetail)
        
        let cacheObject = CacheObject(data: data, timestamp: timeProvider.now())
        let encodedObject = try encoder.encode(cacheObject)
        userDefaults.set(encodedObject, forKey: userDetailsPrefix + userDetail.login)
    }
    
    func getUserDetail(forUsername username: String) throws -> UserDetail? {
        guard let cachedData = userDefaults.data(forKey: userDetailsPrefix + username) else {
            return nil
        }
        let decoder = JSONDecoder()
        let cacheObject = try decoder.decode(CacheObject.self, from: cachedData)
        
        if cacheObject.timestamp.addingTimeInterval(cacheExpirationInterval) < timeProvider.now() {
            return nil
        }
        
        return try decoder.decode(UserDetail.self, from: cacheObject.data)
    }
}

private struct CacheObject: Codable {
    let data: Data
    let timestamp: Date
}

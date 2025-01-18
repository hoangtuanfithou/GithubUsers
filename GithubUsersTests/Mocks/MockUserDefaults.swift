//
//  MockUserDefaults.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation
@testable import GithubUsers

final class MockUserDefaults: UserDefaultsProtocol {
    var storage: [String: Any] = [:]
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
}

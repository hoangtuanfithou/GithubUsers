//
//  UserDefaultsProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

//
//  DefaultTimeProvider.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

struct DefaultTimeProvider: TimeProviderProtocol {
    func now() -> Date {
        return Date()
    }
}

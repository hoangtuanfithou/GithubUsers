//
//  MockTimeProvider.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation
@testable import GithubUsers

final class MockTimeProvider: TimeProviderProtocol {
    var currentTime: Date
    
    init(currentTime: Date = Date()) {
        self.currentTime = currentTime
    }
    
    func now() -> Date {
        return currentTime
    }
}

//
//  StorageServiceTests.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import XCTest
@testable import GithubUsers

private final class StorageServiceTests: XCTestCase {
    private final var sut: StorageService!
    private var mockUserDefaults: MockUserDefaults!
    private var mockTimeProvider: MockTimeProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUserDefaults = MockUserDefaults()
        mockTimeProvider = MockTimeProvider()
        sut = StorageService(
            userDefaults: mockUserDefaults,
            timeProvider: mockTimeProvider
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockUserDefaults = nil
        mockTimeProvider = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Users Tests
    func testSaveUsers() throws {
        // Given
        let users = [User.mock()]
        
        // When
        try sut.saveUsers(users)
        
        // Then
        XCTAssertNotNil(mockUserDefaults.storage["cached_users"])
    }
    
    func testGetUsers_WithValidCache() throws {
        // Given
        let users = [User.mock()]
        try sut.saveUsers(users)
        
        // When
        let retrievedUsers = try sut.getUsers()
        
        // Then
        XCTAssertEqual(retrievedUsers.count, 1)
        XCTAssertEqual(retrievedUsers.first?.login, "test")
    }
    
    func testGetUsers_WithExpiredCache() throws {
        // Given
        let users = [User.mock()]
        try sut.saveUsers(users)
        
        // Move time forward past cache expiration
        mockTimeProvider.currentTime = Date().addingTimeInterval(25 * 60 * 60) // 25 hours
        
        // When
        let retrievedUsers = try sut.getUsers()
        
        // Then
        XCTAssertTrue(retrievedUsers.isEmpty)
    }
    
    func testGetUsers_WithEmptyCache() throws {
        // When
        let retrievedUsers = try sut.getUsers()
        
        // Then
        XCTAssertTrue(retrievedUsers.isEmpty)
    }
    
    // MARK: - User Detail Tests
    func testSaveUserDetail() throws {
        // Given
        let userDetail = UserDetail.mock()
        
        // When
        try sut.saveUserDetail(userDetail)
        
        // Then
        XCTAssertNotNil(mockUserDefaults.storage["user_detail_test"])
    }
    
    func testGetUserDetail_WithValidCache() throws {
        // Given
        let userDetail = UserDetail.mock()
        try sut.saveUserDetail(userDetail)
        
        // When
        let retrievedDetail = try sut.getUserDetail(forUsername: "test")
        
        // Then
        XCTAssertNotNil(retrievedDetail)
        XCTAssertEqual(retrievedDetail?.login, "test")
    }
    
    func testGetUserDetail_WithExpiredCache() throws {
        // Given
        let userDetail = UserDetail.mock()
        try sut.saveUserDetail(userDetail)
        
        // Move time forward past cache expiration
        mockTimeProvider.currentTime = Date().addingTimeInterval(25 * 60 * 60) // 25 hours
        
        // When
        let retrievedDetail = try sut.getUserDetail(forUsername: "test")
        
        // Then
        XCTAssertNil(retrievedDetail)
    }
    
    func testGetUserDetail_WithNonexistentUser() throws {
        // When
        let retrievedDetail = try sut.getUserDetail(forUsername: "nonexistent")
        
        // Then
        XCTAssertNil(retrievedDetail)
    }
}

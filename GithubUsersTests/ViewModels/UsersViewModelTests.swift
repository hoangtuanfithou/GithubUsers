//
//  MockNetworkService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/19.
//

import XCTest
@testable import GithubUsers

final class UsersViewModelTests: XCTestCase {
    var sut: UsersViewModel!
    var mockNetworkService: MockNetworkService!
    var mockStorageService: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        sut = UsersViewModel(
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockStorageService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testInit_LoadsCachedUsers() {
        // Given
        let cachedUsers = [User.mock()]
        mockStorageService.savedUsers = cachedUsers
        
        // When
        sut = UsersViewModel(
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
        
        // Then
        XCTAssertEqual(sut.users, cachedUsers)
    }
    
    func testInit_HandlesCacheError() {
        // Given
        mockStorageService.error = TestError.someError
        
        // When
        sut = UsersViewModel(
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
        
        // Then
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    // MARK: - Load More Tests
    func testLoadMore_Success() async {
        // Given
        let newUsers = [User.mock()]
        mockNetworkService.users = newUsers
        
        // When
        await sut.loadMoreUsers()
        
        // Then
        XCTAssertEqual(sut.users, newUsers)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(mockStorageService.savedUsers, newUsers)
    }
    
    func testLoadMore_HandlesError() async {
        // Given
        mockNetworkService.error = TestError.someError
        
        // When
        await sut.loadMoreUsers()
        
        // Then
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    func testLoadMore_PreventsConcurrentCalls() async {
        // Given
        sut.isLoading = true
        
        // When
        await sut.loadMoreUsers()
        
        // Then
        XCTAssertTrue(mockNetworkService.users.isEmpty)
    }
    
    func testLoadMore_FiltersExistingUsers() async {
        // Given
        let existingUser = User.mock(id: 1)
        sut.users = [existingUser]
        
        let newUsers = [
            existingUser,
            User.mock(id: 2)
        ]
        mockNetworkService.users = newUsers
        
        // When
        await sut.loadMoreUsers()
        
        // Then
        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.users.first?.id, 1)
        XCTAssertEqual(sut.users.last?.id, 2)
    }
    
    func testLoadMore_UsesPreviousUserID() async {
        // Given
        let existingUser = User.mock(id: 1, login: "test1")
        sut.users = [existingUser]
        
        let newUser = User.mock(id: 2, login: "test2")
        mockNetworkService.users = [newUser]
        
        // When
        await sut.loadMoreUsers()
        
        // Then
        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.users.last?.id, 2)
    }
}

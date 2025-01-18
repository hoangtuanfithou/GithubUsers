//
//  UserDetailViewModelTests.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/19.
//

import XCTest
import Combine
@testable import GithubUsers

final class UserDetailViewModelTests: XCTestCase {
    var sut: UserDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockStorageService: MockStorageService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        sut = UserDetailViewModel(
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        mockNetworkService = nil
        mockStorageService = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Cache Tests
    func testLoadUserDetail_UsesCachedDataAndThenNetwork() async {
        // Given
        let cachedDetail = UserDetail.mock(login: "Cached User")
        let networkDetail = UserDetail.mock(login: "Network User")
        
        mockStorageService.cachedUserDetail = cachedDetail
        mockNetworkService.userDetail = networkDetail
        
        var userDetailUpdates: [UserDetail?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 2 // Expect both cache and network updates
        
        sut.$userDetail
            .dropFirst() // Drop initial nil
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail(username: "Cached User")
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
                
        // Verify we got both cache and network updates in correct order
        XCTAssertEqual(userDetailUpdates.count, 2)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Cached User")
        XCTAssertEqual(userDetailUpdates[1]?.login, "Network User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        
        // Verify the final state is from network
        XCTAssertEqual(sut.userDetail?.login, "Network User")
    }
    
    func testLoadUserDetail_HandlesNoCacheAndNetwork() async {
        // Given
        let networkDetail = UserDetail.mock(login: "Network User")
        mockNetworkService.userDetail = networkDetail
        
        var userDetailUpdates: [UserDetail?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 1 // Only expect network update
        
        sut.$userDetail
            .dropFirst() // Drop initial nil
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
        
        XCTAssertEqual(userDetailUpdates.count, 1)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Network User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testLoadUserDetail_HandlesCacheSuccessAndNetworkFailure() async {
        // Given
        let cachedDetail = UserDetail.mock(login: "Cached User")
        mockStorageService.cachedUserDetail = cachedDetail
        mockNetworkService.error = TestError.someError
        
        var userDetailUpdates: [UserDetail?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 1 // Only expect cache update
        
        sut.$userDetail
            .dropFirst() // Drop initial nil
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail(username: "Cached User")
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
        
        XCTAssertEqual(userDetailUpdates.count, 1)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Cached User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        
        // Verify we keep the cached data even when network fails
        XCTAssertEqual(sut.userDetail?.login, "Cached User")
    }
    
    // MARK: - Network Tests
    func testLoadUserDetail_FetchesFromNetwork_WhenNoCacheAvailable() async {
        // Given
        let networkDetail = UserDetail.mock(login: "test")
        mockNetworkService.userDetail = networkDetail
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        XCTAssertEqual(sut.userDetail?.login, networkDetail.login)
        XCTAssertEqual(sut.userDetail?.id, networkDetail.id)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testLoadUserDetail_SavesToCache_AfterNetworkFetch() async {
        // Given
        let networkDetail = UserDetail.mock()
        mockNetworkService.userDetail = networkDetail
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        XCTAssertEqual(mockStorageService.savedUserDetail?.login, networkDetail.login)
        XCTAssertEqual(mockStorageService.savedUserDetail?.id, networkDetail.id)
    }
    
    func testLoadUserDetail_HandlesNetworkError() async {
        // Given
        mockNetworkService.error = TestError.someError
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        XCTAssertNil(sut.userDetail)
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadUserDetail_ManagesLoadingState() async {
        // Given
        let networkDetail = UserDetail.mock()
        mockNetworkService.userDetail = networkDetail
        
        let loadingStates = expectation(description: "Loading states")
        loadingStates.expectedFulfillmentCount = 2  // Expect both true and false states
        
        var loadingStateChanges: [Bool] = []
        
        sut.$isLoading
            .dropFirst()  // Skip initial false state
            .sink { isLoading in
                loadingStateChanges.append(isLoading)
                loadingStates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        await fulfillment(of: [loadingStates], timeout: 0.3)
        
        // Verify the loading state transitions
        XCTAssertEqual(loadingStateChanges, [true, false])
    }
    
    func testLoadUserDetail_HandlesStorageSaveError() async {
        // Given
        let networkDetail = UserDetail.mock()
        mockNetworkService.userDetail = networkDetail
        mockStorageService.error = TestError.someError
        
        // When
        await sut.loadUserDetail(username: "test")
        
        // Then
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
}

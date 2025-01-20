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
    private var sut: UserDetailViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockStorageService: MockStorageService!
    private var cancellables: Set<AnyCancellable>!
    private var initialUser: User!
    
    override func setUp() {
        super.setUp()
        initialUser = User.mock()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockStorageService()
        sut = UserDetailViewModel(
            initialUser: initialUser,
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
        cancellables = []
    }
    
    override func tearDown() {
        initialUser = nil
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
        
        var userDetailUpdates: [UserDisplayInfo?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 2 // Expect both cache and network updates
        
        sut.$displayUser
            .dropFirst() // Drop initial user
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail()
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
                
        // Verify we got both cache and network updates in correct order
        XCTAssertEqual(userDetailUpdates.count, 2)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Cached User")
        XCTAssertEqual(userDetailUpdates[1]?.login, "Network User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.hasFullDetails)

        // Verify the final state is from network
        XCTAssertEqual(sut.displayUser.login, "Network User")
    }
    
    func testLoadUserDetail_HandlesNoCacheAndNetwork() async {
        // Given
        let networkDetail = UserDetail.mock(login: "Network User")
        mockNetworkService.userDetail = networkDetail
        
        var userDetailUpdates: [UserDisplayInfo?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 1 // Only expect network update
        
        sut.$displayUser
            .dropFirst() // Drop initial user
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail()
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
        
        XCTAssertEqual(userDetailUpdates.count, 1)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Network User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.hasFullDetails)
    }
    
    func testLoadUserDetail_HandlesCacheSuccessAndNetworkFailure() async {
        // Given
        let cachedDetail = UserDetail.mock(login: "Cached User")
        mockStorageService.cachedUserDetail = cachedDetail
        mockNetworkService.error = TestError.someError
        
        var userDetailUpdates: [UserDisplayInfo?] = []
        
        let expectUpdates = expectation(description: "User detail updates")
        expectUpdates.expectedFulfillmentCount = 1 // Only expect cache update
        
        sut.$displayUser
            .dropFirst() // Drop initial user
            .sink { detail in
                userDetailUpdates.append(detail)
                expectUpdates.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        await sut.loadUserDetail()
        
        // Then
        await fulfillment(of: [expectUpdates], timeout: 1.0)
        
        XCTAssertEqual(userDetailUpdates.count, 1)
        XCTAssertEqual(userDetailUpdates[0]?.login, "Cached User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.hasFullDetails)

        // Verify we keep the cached data even when network fails
        XCTAssertEqual(sut.displayUser.login, "Cached User")
    }
    
    // MARK: - Network Tests
    func testLoadUserDetail_FetchesFromNetwork_WhenNoCacheAvailable() async {
        // Given
        let networkDetail = UserDetail.mock(login: "Network User")
        mockNetworkService.userDetail = networkDetail
        
        // When
        await sut.loadUserDetail()
        
        // Then
        XCTAssertEqual(sut.displayUser.login, "Network User")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.hasFullDetails)
    }
    
    func testLoadUserDetail_SavesToCache_AfterNetworkFetch() async {
        // Given
        let networkDetail = UserDetail.mock()
        mockNetworkService.userDetail = networkDetail
        
        // When
        await sut.loadUserDetail()
        
        // Then
        XCTAssertEqual(mockStorageService.savedUserDetail?.login, networkDetail.login)
        XCTAssertEqual(mockStorageService.savedUserDetail?.id, networkDetail.id)
    }
    
    func testLoadUserDetail_HandlesNetworkError() async {
        // Given
        mockNetworkService.error = TestError.someError
        
        // When
        await sut.loadUserDetail()
        
        // Then
        XCTAssertEqual(sut.displayUser.login, initialUser.login)
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.hasFullDetails)
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
        await sut.loadUserDetail()
        
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
        await sut.loadUserDetail()
        
        // Then
        XCTAssertEqual(sut.displayUser.login, networkDetail.login)
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hasFullDetails)
    }
}

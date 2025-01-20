//
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Combine

final class UserDetailViewModel: ObservableObject {
    // Published properties
    @Published private(set) var displayUser: UserDisplayInfo
    @Published var isLoading = false
    @Published var error: Error?
    @Published private(set) var hasFullDetails = false
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(
        initialUser: User,
        networkService: NetworkServiceProtocol = NetworkService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.displayUser = UserDisplayInfo(from: initialUser)
        self.networkService = networkService
        self.storageService = storageService
    }
    
    @MainActor
    func loadUserDetail() async {
        isLoading = true
        
        defer { isLoading = false }
        // Try to load from cache first
        if let cached = try? storageService.getUserDetail(forUsername: displayUser.login) {
            displayUser = UserDisplayInfo(from: cached)
            hasFullDetails = true
        }
        
        do {
            let detail = try await networkService.fetchUserDetail(username: displayUser.login)
            displayUser = UserDisplayInfo(from: detail)
            hasFullDetails = true
            try storageService.saveUserDetail(detail)
        } catch {
            self.error = error
        }
    }
}

//
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Combine

class UserDetailViewModel: ObservableObject {
    @Published var userDetail: UserDetail?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    @MainActor
    func loadUserDetail(username: String) async {
        isLoading = true
        
        // Try to load from cache first
        if let cached = try? storageService.getUserDetail(forUsername: username) {
            userDetail = cached
            isLoading = false
            return
        }
        
        do {
            let detail = try await networkService.fetchUserDetail(username: username)
            userDetail = detail
            try storageService.saveUserDetail(detail)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}

//
//  UsersViewModel.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Combine

final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
        loadCachedUsers()
    }
    
    private func loadCachedUsers() {
        do {
            users = try storageService.getUsers()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func loadMoreUsers() async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        do {
            let newUsers = try await networkService.fetchUsers(since: users.last?.id ?? 0)
            
            let existingIDs = Set(users.map { $0.id })
            
            users.append(contentsOf: newUsers.filter { !existingIDs.contains($0.id) })
            
            try storageService.saveUsers(users)
        } catch {
            self.error = error
        }
    }
}

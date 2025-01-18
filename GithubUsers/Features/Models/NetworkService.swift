//
//  NetworkService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = Constants.baseURL
    private let token = Constants.token
    private let perPage = Constants.pageSize
    
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
   
    func fetchUsers(since: Int) async throws -> [User] {
        let url = URL(string: "\(baseURL)/users?per_page=\(perPage)&since=\(since)")!
        let request = makeRequest(for: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode([User].self, from: data)
    }
    
    func fetchUserDetail(username: String) async throws -> UserDetail {
        let url = URL(string: "\(baseURL)/users/\(username)")!
        let request = makeRequest(for: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(UserDetail.self, from: data)
    }
    
}

// MARK: - Helpers

private extension NetworkService {
    func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

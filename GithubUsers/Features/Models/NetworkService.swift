//
//  NetworkService.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

/// A service to handle network requests for fetching user data.
final class NetworkService: NetworkServiceProtocol {

    /// A session for making network requests.
    private let urlSession: URLSessionProtocol

    /// Initializes the network service with an optional custom URLSession.
    /// - Parameter urlSession: The URLSession to use. Defaults to `URLSession.shared`.
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
   
    func fetchUsers(since: Int) async throws -> [User] {
        let url = URL(string: "\(Constants.baseURL)/users?per_page=\(Constants.pageSize)&since=\(since)")!
        let request = makeRequest(for: url)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode([User].self, from: data)
    }
    
    func fetchUserDetail(username: String) async throws -> UserDetail {
        let url = URL(string: "\(Constants.baseURL)/users/\(username)")!
        let request = makeRequest(for: url)
        let (data, _) = try await urlSession.data(for: request)
        return try JSONDecoder().decode(UserDetail.self, from: data)
    }
}

// MARK: - Helpers

private extension NetworkService {
    /// Creates a URLRequest for the given URL with the appropriate Authorization header.
    /// - Parameter url: The URL to create the request for.
    /// - Returns: A configured `URLRequest` with the Authorization header.
    func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        if !Constants.token.isEmpty {
            request.setValue("token \(Constants.token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

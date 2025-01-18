//
//  URLSessionProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

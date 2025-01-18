//
//  StorageServiceProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

protocol StorageServiceProtocol {
    func saveUsers(_ users: [User]) throws
    func getUsers() throws -> [User]
    func saveUserDetail(_ userDetail: UserDetail) throws
    func getUserDetail(forUsername username: String) throws -> UserDetail?
}

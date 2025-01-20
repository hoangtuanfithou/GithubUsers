//
//  StorageServiceProtocol.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

protocol StorageServiceProtocol {
    /// Saves an array of users to persistent storage.
    /// - Parameter users: The users to be saved.
    /// - Throws: An error if the users could not be saved.
    func saveUsers(_ users: [User]) throws

    /// Retrieves all saved users from persistent storage.
    /// - Returns: An array of `User` objects.
    /// - Throws: An error if the users could not be retrieved.
    func getUsers() throws -> [User]

    /// Saves the detailed information of a specific user to persistent storage.
    /// - Parameter userDetail: The user details to be saved.
    /// - Throws: An error if the user detail could not be saved.
    func saveUserDetail(_ userDetail: UserDetail) throws

    /// Retrieves the saved details for a user based on their username.
    /// - Parameter username: The username of the user whose details are to be retrieved.
    /// - Returns: A `UserDetail` object if found, or `nil` if no details are saved for the user.
    /// - Throws: An error if the user detail could not be retrieved.
    func getUserDetail(forUsername username: String) throws -> UserDetail?
}

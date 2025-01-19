# GitHub User Browser

## Overview
This mobile application allows administrators to browse a list of users from a GitHub site and view detailed information about each user. The app supports pagination, caching, and navigation to a detailed user profile page.

## Features

- **User List**: Displays a paginated list of GitHub users, including their avatar, username, and profile link. Fetches 20 users per page, with additional users loaded upon scrolling.
  
- **User Detail**: Clicking on a user navigates to a detailed profile page that provides more information, such as location, followers, and following.

- **Caching**: User list information is displayed instantly on the second launch using cached data. Caching is implemented for both the list and detail views, with pull-to-refresh functionality for the user list.

- **MVVM Design Pattern**: The project follows the MVVM (Model-View-ViewModel) pattern, effectively separating the UI, business logic, and data layers.

- **Light/Dark Mode Support**: Supports both light and dark mode themes.

- **SwiftUI and Combine**: Built using SwiftUI for UI components, Combine and async/await.

- **Unit Tests**: Unit tests cover the **ViewModels** and **Services**.

- **Document**: Added documentation and comments for the services layer and key functions.

## API Endpoints
- **List Users (Paged)**  
  `GET https://api.github.com/users?per_page=20&since=100`  
  Fetches a list of users with pagination.  
  Response includes: `login`, `avatar_url`, and `html_url`.

- **User Detail**  
  `GET https://api.github.com/users/{login_username}`  
  Fetches detailed information about a specific user.  
  Response includes: `login`, `avatar_url`, `html_url`, `location`, `followers`, `following`.

## Project Design Pattern
- **MVVM Architecture**: The app follows the MVVM design pattern, where the:
  - **Model** represents the data structures (e.g., `User`, `UserDetail`).
  - **View** represents the UI (e.g., `UserListView`, `UserDetailView`).
  - **ViewModel** handles the logic and communicates between the model and the view (e.g., `UsersViewModel`, `UserDetailViewModel`).

## Environment
- **Xcode**: 16.2
- **Minimum iOS Version**: iOS 17.0
- **Supported Platforms**: iOS and macOS

## Key Classes
- **Views**:
  - `UserListView`: Displays the list of users.
  - `UserDetailView`: Displays detailed information about a selected user.
  
- **Models**:
  - `User`: Represents a basic GitHub user with properties such as `login`, `avatar_url`, and `html_url`.
  - `UserDetail`: Represents detailed information about a user, including `location`, `followers`, and `following`.
  - `StorageService`: Handles local caching and data storage.
  - `NetworkService`: Manages network requests to fetch user data from the GitHub API.
  
- **ViewModels**:
  - `UsersViewModel`: Fetches and provides data for the user list view.
  - `UserDetailViewModel`: Fetches and provides detailed information for the user detail view.

## Notes:
The app still has room for improvement. Thank you, team, for your review 🖤

## Screenshots
![screen recording](<Documents/Simulator Screen Recording - iPhone 16 - 2025-01-19 at 11.49.09.gif>)

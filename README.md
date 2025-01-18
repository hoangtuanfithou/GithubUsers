# GitHub User Browser

## Overview
This mobile application allows administrators to browse a list of users from a GitHub site and view detailed information about each user. The app supports pagination, caching, and navigation to a detailed user profile page.

## Features
- **List of Users**: Displays a paginated list of GitHub users with their avatar, username, and profile link.
- **User Detail**: Clicking on a user navigates to a detailed profile page with more information such as location, followers, and following.
- **Pagination**: Fetches and displays 20 users per page. More users can be fetched by scrolling down.
- **Caching**: User information is displayed instantly on the second launch of the application, using cached data.

## API Endpoints
- **List Users (Paged)**  
  `GET https://api.github.com/users?per_page=20&since=100`  
  Fetches a list of users with pagination.  
  Response includes: `login`, `avatar_url`, and `html_url`.

- **User Detail**  
  `GET https://api.github.com/users/{login_username}`  
  Fetches detailed information about a specific user.  
  Response includes: `login`, `avatar_url`, `html_url`, `location`, `followers`, `following`.

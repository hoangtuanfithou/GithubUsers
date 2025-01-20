//
//  UserDetailView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject private var viewModel: UserDetailViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserDetailViewModel(initialUser: user))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Card - Always show with initial user data
                UserCardView(
                    avatarUrl: viewModel.displayUser.avatarUrl,
                    userName: viewModel.displayUser.login,
                    location: viewModel.displayUser.location
                )
                
                // Stats Section - Show when full details are available
                if viewModel.hasFullDetails {
                    HStack(spacing: 40) {
                        StatisticInfoView(
                            icon: "person.2.fill",
                            title: "Followers",
                            count: viewModel.displayUser.followers
                        )
                        StatisticInfoView(
                            icon: "medal.fill",
                            title: "Following",
                            count: viewModel.displayUser.following
                        )
                    }
                }
                
                // Landing page
                BlogInfoView(
                    blogUrl: URL(string: viewModel.displayUser.htmlUrl)!
                )
                
                if viewModel.isLoading {
                    ProgressView("Updating user details...")
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("User Detail")
        .task {
            await viewModel.loadUserDetail()
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
}

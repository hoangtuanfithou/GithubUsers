//
//  UserDetailView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    @StateObject private var viewModel = UserDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading user details...")
                    .padding()
            } else if let userDetail = viewModel.userDetail {
                VStack(spacing: 20) {
                    // Profile Card
                    UserCardView(
                        avatarUrl: userDetail.avatarUrl,
                        userName: userDetail.login,
                        location: userDetail.location
                    )
                    
                    // Stats Section
                    HStack(spacing: 40) {
                        StatisticInfoView(
                            icon: "person.2.fill",
                            title: "Followers",
                            count: userDetail.followers
                        )
                        StatisticInfoView(
                            icon: "medal.fill",
                            title: "Following",
                            count: userDetail.following
                        )
                    }
                    
                    // Landing page
                    VStack(alignment: .leading) {
                        Text("Blog").font(.title)
                        Link(
                            userDetail.htmlUrl,
                            destination: URL(string: userDetail.htmlUrl)!
                        ).font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
            }
        }
        .navigationTitle("User Detail")
        .task {
            await viewModel.loadUserDetail(username: user.login)
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

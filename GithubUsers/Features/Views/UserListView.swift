//
//  UserListView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users) { user in
                    HStack(spacing: 0) {
                        UserCardView(
                            avatarUrl: user.avatarUrl,
                            userName: user.login,
                            landingPageUrl: user.htmlUrl
                        )
                        
                        NavigationLink(destination: UserDetailView(user: user)) {
                            EmptyView()
                        }
                        .frame(width: 0)
                        .opacity(0)
                    }
                }
                .listRowSeparator(.hidden)
                
                // Load more
                if !viewModel.users.isEmpty {
                    ProgressView()
                        .onAppear {
                            Task {
                                await viewModel.loadMoreUsers()
                            }
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Github Users")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                if viewModel.users.isEmpty {
                    await viewModel.loadMoreUsers()
                }
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
}

#Preview {
    UserListView()
}

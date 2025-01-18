//
//  UserListView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserListView: View {
    var body: some View {
        NavigationStack {
            List(1...6, id: \.self) { _ in
                HStack(spacing: 0) {
                    UserCardView(
                        avatarUrl: User.sample.avatarUrl,
                        userName: User.sample.login,
                        landingPageUrl: User.sample.htmlUrl
                    )
                    
                    NavigationLink(destination: UserDetailView(user: .sample)) {
                        EmptyView()
                    }
                    .frame(width: 0)
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Github Users")
        }
    }
}

#Preview {
    UserListView()
}

//
//  UserDetailView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                UserCardView(
                    avatarUrl: user.avatarUrl,
                    userName: user.login
                )
            }
            .padding()
        }
        .navigationTitle("User Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: .sample)
    }
}

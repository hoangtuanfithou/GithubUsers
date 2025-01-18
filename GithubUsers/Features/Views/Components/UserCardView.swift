//
//  UserRowView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct UserCardView: View {
    let avatarUrl: String
    let userName: String
    var landingPageUrl: String?
    var location: String?
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            Spacer(minLength: 8)
            
            VStack(alignment: .leading) {
                Text(userName)
                    .font(.title)
                
                if let landingPageUrl = landingPageUrl {
                    Divider().padding(.vertical, -8)
                    Text(landingPageUrl)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let location = location {
                    Divider().padding(.vertical, -8)
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(location)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
            }.frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding()
        .background(.background)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    VStack {
        UserCardView(
            avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
            userName: "mojombo",
            landingPageUrl: "https://github.com/mojombo"
        )
        UserCardView(
            avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
            userName: "mojombo"
        )
    }.padding()
}

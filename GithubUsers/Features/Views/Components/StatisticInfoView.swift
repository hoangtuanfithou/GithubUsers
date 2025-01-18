//
//  StatisticInfoView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct StatisticInfoView: View {
    let icon: String
    let title: String
    let count: Int
    
    var body: some View {
        VStack {
            ZStack {
                Color.gray.opacity(0.2)
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(16)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
                
            Text("\(count)+")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .shadow(radius: 5)
    }
}

#Preview {
    HStack(spacing: 20) {
        StatisticInfoView(
            icon: "person.2.fill",
            title: "Followers",
            count: 100
        )
        StatisticInfoView(
            icon: "medal.fill",
            title: "Following",
            count: 50
        )
    }
}

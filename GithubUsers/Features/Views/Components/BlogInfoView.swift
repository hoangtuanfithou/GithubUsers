//
//  BlogInfoView.swift
//  GithubUsers
//
//  Created by Tuan on 2025/01/18.
//

import SwiftUI

struct BlogInfoView: View {
    let blogUrl: URL

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blog")
                .font(.title)
                .fontWeight(.bold)
            
            Link(blogUrl.absoluteString, destination: blogUrl)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    BlogInfoView(blogUrl: URL(string: "https://www.google.com")!)
}

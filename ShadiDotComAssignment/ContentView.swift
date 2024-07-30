////
////  ContentView.swift
////  ShadiDotComAssignment
////
////  Created by Anubhav Singh on 29/07/24.
////

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        TabView {
            NavigationView {
                List(viewModel.users) { user in
                    MatchCardView(viewModel: viewModel, user: user)
                }
                .onAppear {
                    viewModel.fetchUsers()
                }
                .navigationTitle("All Users")
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Users")
            }

            NavigationView {
                List(viewModel.acceptedUsers) { user in
                    UserRowView(user: user)
                }
                .navigationTitle("Accepted Users")
            }
            .tabItem {
                Image(systemName: "checkmark.circle.fill")
                Text("Accepted")
            }

            NavigationView {
                List(viewModel.rejectedUsers) { user in
                    UserRowView(user: user)
                }
                .navigationTitle("Rejected Users")
            }
            .tabItem {
                Image(systemName: "xmark.circle.fill")
                Text("Rejected")
            }
        }
        .onAppear {
            viewModel.loadStoredUsers()
        }
    }
}

struct UserRowView: View {
    var user: User

    var body: some View {
        HStack {
            if let urlString = user.picture.thumbnail,
               let url = URL(string: urlString) {
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
            }
        }
    }
}

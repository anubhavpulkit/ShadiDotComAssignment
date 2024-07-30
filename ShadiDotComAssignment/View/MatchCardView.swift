////
////  MatchCardView.swift
////  ShadiDotComAssignment
////
////  Created by Anubhav Singh on 29/07/24.
////

import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    @ObservedObject var viewModel: UserViewModel
    var user: User

    var body: some View {
        VStack {
            if let status = user.status {
                if let urlString = user.picture.large,
                   let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                Text("\(user.name.first) \(user.name.last)")
                    .font(.title)
                Text(user.email)
                    .font(.subheadline)
                HStack{
                    Text(user.gender)
                        .font(.subheadline)
                    Text("\(user.dob.age)")
                        .font(.subheadline)
                }
                Text(status)
                    .font(.headline)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else {
                if let urlString = user.picture.large,
                   let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                Text("\(user.name.first) \(user.name.last)")
                    .font(.title)
                Text(user.email)
                    .font(.subheadline)
                HStack{
                    Text(user.gender)
                        .font(.subheadline)
                    Text("\(user.dob.age)")
                        .font(.subheadline)
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.acceptUser(user)
                    }) {
                        Text("Accept")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.declineUser(user)
                    }) {
                        Text("Decline")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

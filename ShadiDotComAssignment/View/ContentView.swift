import SwiftUI
import SDWebImageSwiftUI

// Main view of the app
struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        TabView {
            NavigationView {
                UserListView(viewModel: viewModel)
                    .navigationTitle("All Users")
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Users")
            }

            NavigationView {
                UserListView(viewModel: viewModel, isAccepted: true)
                    .navigationTitle("Accepted Users")
            }
            .tabItem {
                Image(systemName: "checkmark.circle.fill")
                Text("Accepted")
            }

            NavigationView {
                UserListView(viewModel: viewModel, isAccepted: false)
                    .navigationTitle("Rejected Users")
            }
            .tabItem {
                Image(systemName: "xmark.circle.fill")
                Text("Rejected")
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

// View for displaying a list of users
struct UserListView: View {
    @ObservedObject var viewModel: UserViewModel
    var isAccepted: Bool? = nil

    var body: some View {
        List(users) { user in
            MatchCardView(viewModel: viewModel, user: user)
        }
    }

    private var users: [User] {
        if let isAccepted = isAccepted {
            return isAccepted ? viewModel.acceptedUsers : viewModel.rejectedUsers
        } else {
            return viewModel.users
        }
    }
}

// View for displaying a user's profile card


// Component for displaying profile pictures
struct ProfilePicture: View {
    let urlString: String?
    
    var body: some View {
        if let urlString = urlString, let url = URL(string: urlString) {
            WebImage(url: url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 5)
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .foregroundColor(.gray)
                .shadow(radius: 5)
        }
    }
}

// Custom button component
struct ActionButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(color)
                .cornerRadius(10)
        }.frame(width: 100, height: 40)
    }
}

import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    @ObservedObject var viewModel: UserViewModel
    var user: User
    
    var body: some View {
        VStack {
            ProfilePicture(urlString: user.picture.large)
            Text("\(user.name.first) \(user.name.last)")
                .font(.title)
                .fontWeight(.bold)
            Text(user.location.city)
                .font(.subheadline)
                .foregroundColor(.white)
            
            if user.status != nil {
                Text(user.status ?? "")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.7))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else {
                Text("\(user.gender), Age: \(user.dob.age)")
                    .font(.title2)
                    .padding(.bottom, 10)
                
                HStack(spacing: 30) {
                    ActionButton(title: "Accept", color: .green) {
                        viewModel.acceptUser(user)
                    }
                    .frame(width: 100, height: 40)
                    
                    ActionButton(title: "Reject", color: .red) {
//                        viewModel.declineUser(user)
                    }
                    .frame(width: 100, height: 40)
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.75, height: 450)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

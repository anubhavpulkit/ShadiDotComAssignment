import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    @ObservedObject var viewModel: UserViewModel
    var user: User
    var isAccepted: Bool
    
    var body: some View {
        VStack {
            ProfilePicture(urlString: user.pictureLarge ?? user.picture.large)
            Text("\(user.name.first) \(user.name.last)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("\(user.location.city) \(user.location.state)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(user.gender), Age: \(user.dob.age)")
                .font(.title3)
                .padding(.bottom, 10)
                .foregroundColor(.primary)

            if user.status != nil {
               if  isAccepted {
                   Text(user.phone)
                       .font(.title2)
                       .foregroundColor(.green)
                   Text(user.email)
                       .font(.subheadline)
                       .foregroundColor(.secondary)
                }
                Text(user.status ?? "")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            } else {
                HStack(spacing: 30) {
                    ActionButton(title: "Accept", color: .green) {
                        viewModel.acceptUser(user)
                    }
                    .frame(width: 100, height: 40)
                    
                    ActionButton(title: "Reject", color: .red) {
                        viewModel.declineUser(user)
                    }
                    .frame(width: 100, height: 40)
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.75, height: 350)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

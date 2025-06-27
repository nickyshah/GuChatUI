import SwiftUI

struct AuthenticatedHomeView: View {
    @EnvironmentObject var authFlowManager: AuthFlowManager

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome, \(authFlowManager.username)!") // Display username if available
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("You are successfully authenticated.")
                .font(.headline)

            if let token = APIManager.shared.authToken {
                Text("Auth Token (first 20 chars): \(token.prefix(20))...")
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding()
            }
            if let userId = APIManager.shared.currentUserId {
                Text("User ID: \(userId)")
                    .font(.caption)
            }


            Button("Logout") {
                authFlowManager.resetFlow() // Resets the flow and logs out
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .padding(.horizontal)
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
    }
}

struct AuthenticatedHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticatedHomeView().environmentObject(AuthFlowManager())
        }
    }
}

import SwiftUI

struct ResetPasswordPageView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showingPassword = false
    @State private var showingConfirmPassword = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Top Nav
                HStack {
                    NavigationLink(destination: Text("LoginPageView Placeholder")) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Title
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 30)

                // Inputs
                PasswordInputSection(
                    viewModel: viewModel,
                    showingPassword: $showingPassword,
                    showingConfirmPassword: $showingConfirmPassword
                )
                .padding(.horizontal)

                // Requirements
                PasswordRequirementsView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.top, 30)

                Spacer()

                // Reset Button
                Button(action: {
                    print("Reset password: \(viewModel.password)")
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ResetPasswordPageView()
}

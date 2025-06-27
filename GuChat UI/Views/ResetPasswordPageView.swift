import SwiftUI

struct ResetPasswordPageView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showingPassword = false
    @State private var showingConfirmPassword = false

    @State private var showValidationError = false
    @State private var shakePasswordField = false
    @State private var shakeConfirmField = false
    @State private var shakeButton = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // Top Nav
                HStack {
                    NavigationLink(destination: LoginPageView()) {
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
                    showingConfirmPassword: $showingConfirmPassword,
                    showValidationError: $showValidationError,
                    shakePasswordField: $shakePasswordField,
                    shakeConfirmField: $shakeConfirmField
                )
                .padding(.horizontal)

                // Requirements
                PasswordRequirementsView(viewModel: viewModel, shouldHighlightInvalid: showValidationError)
                    .padding(.horizontal)
                    .padding(.top, 30)

                Spacer()

                // Reset Button
                Button(action: {
                    if !viewModel.isPasswordValid || !viewModel.doPasswordsMatch {
                        showValidationError = true
                        shakePasswordField = true
                        shakeConfirmField = true
                        shakeButton = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            shakePasswordField = false
                            shakeConfirmField = false
                            shakeButton = false
                        }
                        return
                    }

                    // TODO: Call reset password logic here
                    print("Resetting password: \(viewModel.password)")
                }) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .modifier(ShakeEffect(animatableData: CGFloat(shakeButton ? 1 : 0)))
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct ResetPasswordPageView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordPageView()
    }
}

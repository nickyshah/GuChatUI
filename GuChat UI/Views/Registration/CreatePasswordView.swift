import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var authFlowManager: AuthFlowManager
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showingPassword = false
    @State private var showingConfirmPassword = false

    @State private var showValidationError = false
    @State private var shakePasswordField = false
    @State private var shakeConfirmField = false
    @State private var shakeButton = false

    var body: some View {
        VStack(spacing: 20) {
            // Back button
            HStack {
                Button(action: {
                    authFlowManager.currentStep = .dobEntry
                    authFlowManager.errorMessage = nil
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Text("Create Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            PasswordInputSection(
                viewModel: viewModel,
                showingPassword: $showingPassword,
                showingConfirmPassword: $showingConfirmPassword,
                showValidationError: $showValidationError,
                shakePasswordField: $shakePasswordField,
                shakeConfirmField: $shakeConfirmField
            )
            .padding(.horizontal)
            
            PasswordRequirementsView(viewModel: viewModel, shouldHighlightInvalid: showValidationError)
                .padding(.top, 10)
                .padding(.leading, -45)
            

            Spacer()

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

                Task {
                    authFlowManager.password = viewModel.password
                    authFlowManager.confirmPassword = viewModel.confirmPassword
                    await authFlowManager.register()
                }
            }) {
                Text(authFlowManager.isLoading ? "Registering..." : "Register Account")
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

// SwiftUI Preview
struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePasswordView().environmentObject(AuthFlowManager())
        }
    }
}

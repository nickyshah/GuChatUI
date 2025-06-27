import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var authFlowManager: AuthFlowManager

    @State private var tappedWhileDisabled = false
    @State private var shakeOffset: CGFloat = 0
    @State private var fieldShakeOffset: CGFloat = 0
    @State private var showFieldError = false
    @State private var showUsernameRequired = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Back Button
                HStack {
                    Button(action: {
                        authFlowManager.currentStep = .otpVerificationRegister
                        authFlowManager.errorMessage = nil
                        authFlowManager.usernameCheckError = nil
                        showFieldError = false
                        showUsernameRequired = false
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Title
                Text("Enter Username")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Username Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack {
                        TextField("Username", text: $authFlowManager.username)
                            .keyboardType(.default)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        (showFieldError || showUsernameRequired || authFlowManager.usernameCheckError != nil)
                                        ? Color.red
                                        : Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                            .offset(x: fieldShakeOffset)
                            .onChange(of: authFlowManager.username) { newValue in
                                if !newValue.isEmpty && authFlowManager.usernameCheckError == nil {
                                    showFieldError = false
                                    showUsernameRequired = false
                                }
                            }

                        if authFlowManager.usernameCheckError != nil {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(.trailing, 8)
                        }
                    }

                    // Username-specific error
                    if let error = authFlowManager.usernameCheckError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }

                    // "Please enter a username" error
                    if showUsernameRequired {
                        Text("Please enter a username")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }

                    // General error
                    if let generalError = authFlowManager.errorMessage {
                        Text(generalError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Continue Button
                Button(action: {
                    let isValid = !authFlowManager.username.isEmpty && authFlowManager.usernameCheckError == nil

                    if isValid {
                        authFlowManager.proceedFromUsername()
                    } else {
                        showFieldError = true
                        tappedWhileDisabled = true

                        // If field is empty, show the special message
                        if authFlowManager.username.isEmpty {
                            showUsernameRequired = true
                        }

                        triggerShakeAnimation()
                        triggerFieldShake()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            tappedWhileDisabled = false
                        }
                    }
                }) {
                    Text(authFlowManager.isLoading ? "Checking..." : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(tappedWhileDisabled ? Color.red : Color.blue)
                        .cornerRadius(10)
                        .offset(x: shakeOffset)
                }
                .disabled(authFlowManager.isLoading)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // Shake button animation
    private func triggerShakeAnimation() {
        withAnimation(.easeIn(duration: 0.1)) {
            shakeOffset = -8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 8
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.1)) {
                shakeOffset = 0
            }
        }
    }

    // Shake input field animation
    private func triggerFieldShake() {
        withAnimation(.easeIn(duration: 0.1)) {
            fieldShakeOffset = -6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                fieldShakeOffset = 6
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.1)) {
                fieldShakeOffset = 0
            }
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsernameView().environmentObject(AuthFlowManager())
        }
    }
}

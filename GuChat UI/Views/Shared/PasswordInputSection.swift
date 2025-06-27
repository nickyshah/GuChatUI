import SwiftUI

struct PasswordInputSection: View {
    @ObservedObject var viewModel: PasswordViewModel
    @Binding var showingPassword: Bool
    @Binding var showingConfirmPassword: Bool
    @Binding var showValidationError: Bool
    @Binding var shakePasswordField: Bool
    @Binding var shakeConfirmField: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Password")
                .fontWeight(.bold)
                .font(.system(size: 22))

            HStack {
                if showingPassword {
                    TextField("Minimum 8 characters", text: $viewModel.password)
                        .foregroundColor(.black)
                } else {
                    SecureField("Minimum 8 characters", text: $viewModel.password)
                        .foregroundColor(.black)
                }
                Button {
                    showingPassword.toggle()
                } label: {
                    Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(showValidationError && !viewModel.hasMinLength ? Color.red : Color(.systemGray4))
            )
            .modifier(ShakeEffect(animatableData: CGFloat(shakePasswordField ? 1 : 0)))

            Text("Confirm Password")
                .fontWeight(.bold)
                .font(.system(size: 22))
                .padding(.top, 20)

            HStack {
                if showingConfirmPassword {
                    TextField("Re-enter password", text: $viewModel.confirmPassword)
                        .foregroundColor(.black)
                } else {
                    SecureField("Re-enter password", text: $viewModel.confirmPassword)
                        .foregroundColor(.black)
                }
                Button {
                    showingConfirmPassword.toggle()
                } label: {
                    Image(systemName: showingConfirmPassword ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(showValidationError && !viewModel.passwordsMatch ? Color.red : Color(.systemGray4))
            )
            .modifier(ShakeEffect(animatableData: CGFloat(shakeConfirmField ? 1 : 0)))

            if showValidationError && viewModel.password.isEmpty {
                Text("Please create a password")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            if !viewModel.passwordsMatch {
                Text("Passwords do not match")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
            }
        }
    }
}

//import SwiftUI
//
//struct PasswordInputSection: View {
//    @ObservedObject var viewModel: PasswordViewModel
//    @Binding var showingPassword: Bool
//    @Binding var showingConfirmPassword: Bool
//    @Binding var showValidationError: Bool
//    @Binding var shakePasswordField: Bool
//    @Binding var shakeConfirmField: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Password")
//                .fontWeight(.bold)
//                .font(.system(size: 22))
//
//            HStack {
//                if showingPassword {
//                    TextField("Minimum 8 characters", text: $viewModel.password)
//                        .foregroundColor(.black)
//                        .textInputAutocapitalization(.never)
//                        .disableAutocorrection(true)
//                } else {
//                    SecureField("Minimum 8 characters", text: $viewModel.password)
//                        .foregroundColor(.black)
//                        .textInputAutocapitalization(.never)
//                        .disableAutocorrection(true)
//                }
//                Button {
//                    showingPassword.toggle()
//                } label: {
//                    Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(8)
//            .overlay(RoundedRectangle(cornerRadius: 8)
//                .stroke(showValidationError && !viewModel.hasMinLength ? Color.red : Color(.systemGray4))
//            )
//            .modifier(ShakeEffect(animatableData: CGFloat(shakePasswordField ? 1 : 0)))
//
//            Text("Confirm Password")
//                .fontWeight(.bold)
//                .font(.system(size: 22))
//                .padding(.top, 20)
//
//            HStack {
//                if showingConfirmPassword {
//                    TextField("Re-enter password", text: $viewModel.confirmPassword)
//                        .foregroundColor(.black)
//                        .textInputAutocapitalization(.never)
//                        .disableAutocorrection(true)
//                } else {
//                    SecureField("Re-enter password", text: $viewModel.confirmPassword)
//                        .foregroundColor(.black)
//                        .textInputAutocapitalization(.never)
//                        .disableAutocorrection(true)
//                }
//                Button {
//                    showingConfirmPassword.toggle()
//                } label: {
//                    Image(systemName: showingConfirmPassword ? "eye.fill" : "eye.slash.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(8)
//            .overlay(RoundedRectangle(cornerRadius: 8)
//                .stroke(showValidationError && !viewModel.passwordsMatch ? Color.red : Color(.systemGray4))
//            )
//            .modifier(ShakeEffect(animatableData: CGFloat(shakeConfirmField ? 1 : 0)))
//
//            if showValidationError && viewModel.password.isEmpty {
//                Text("Please create a password")
//                    .foregroundColor(.red)
//                    .font(.caption)
//            }
//
//            if !viewModel.passwordsMatch {
//                Text("Passwords do not match")
//                    .foregroundColor(.red)
//                    .font(.footnote)
//                    .padding(.top, 4)
//            }
//        }
//    }
//}

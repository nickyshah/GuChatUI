import SwiftUI

struct PasswordInputSection: View {
    @ObservedObject var viewModel: PasswordViewModel
    @Binding var showingPassword: Bool
    @Binding var showingConfirmPassword: Bool
    var showPasswordMismatchError: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Password Field
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
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))

            // Confirm Password Field
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
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))
            
            // Password mismatch error test
            if showPasswordMismatchError && !viewModel.passwordsMatch{
                Text("Password do not match")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
            }
            
        }
    }
}

import SwiftUI

struct PasswordRequirementsView: View {
    @ObservedObject var viewModel: PasswordViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Your password must contain at least:")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            BulletPoint(text: "Total of 8 Characters", isValid: viewModel.hasMinLength)
            BulletPoint(text: "One Lower case letter (a-z)", isValid: viewModel.hasLowercase)
            BulletPoint(text: "One Upper case letter (A-Z)", isValid: viewModel.hasUppercase)
            BulletPoint(text: "One Number (0-9)", isValid: viewModel.hasNumber)
            BulletPoint(text: "One Special character (e.g. !@#$%^&*)", isValid: viewModel.hasSpecialChar)
        }
    }
}

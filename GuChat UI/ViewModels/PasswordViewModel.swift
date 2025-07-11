import SwiftUI
import Combine

class PasswordViewModel: ObservableObject {
    @Published var password: String = ""{
        didSet{ ValidatePassWord() }
    }
    @Published var confirmPassword: String = ""{
        didSet{ ValidatePassWord() }
    }
    @Published var showingPassword: Bool = false
    @Published var showingConfirmPassword: Bool = false
    
    @Published var passwordsMatch: Bool = true

    private func validatePasswords() {
        passwordsMatch = confirmPassword.isEmpty || password == confirmPassword
    }
    
    // Validation flags
        @Published var hasMinLength = false
        @Published var hasLowercase = false
        @Published var hasUppercase = false
        @Published var hasNumber = false
        @Published var hasSpecialChar = false

    var isPasswordValid: Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
          "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$")
        return passwordTest.evaluate(with: password)
    }

    var doPasswordsMatch: Bool {
        password == confirmPassword && !password.isEmpty
    }
    
    private func ValidatePassWord(){
        hasMinLength = password.count >= 8
        hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        hasSpecialChar = password.range(of: "[!@#$%^&*]", options: .regularExpression) != nil
        
        passwordsMatch = confirmPassword.isEmpty || password == confirmPassword
    }
}




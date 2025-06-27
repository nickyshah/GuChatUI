import SwiftUI

// This is the root view that decides which part of the flow to show
struct AuthenticationFlowView: View {
    @StateObject var authFlowManager = AuthFlowManager() // The single source of truth for the auth flow

    var body: some View {
        // Use NavigationStack for multi-step flow
        NavigationStack {
            Group {
                switch authFlowManager.currentStep {
                case .entryPage:
                    EntryPageView()
                case .mobileRegistration:
                    CreateAccountView() // Your initial mobile number entry screen
                case .otpVerification:
                    OTPVerificationView() // OTP entry and verification
                case .usernameEntry:
                    UsernameView() // Username creation and check
                case .dobEntry:
                    DateOfBirthView() // Date of birth entry
                case .createPassword:
                    CreatePasswordView() // Password creation and final registration
                case .login:
                    LoginPageView() // Separate login path
                case .authenticated:
                    AuthenticatedHomeView() // Landing page after successful auth
                }
            }
            .environmentObject(authFlowManager) // Inject AuthFlowManager into the environment
                                                 // so all subviews can access it
        }
    }
}


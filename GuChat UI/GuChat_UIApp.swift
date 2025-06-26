
import SwiftUI
import SwiftData


// This is the root view that decides which part of the flow to show
struct AuthenticationFlowView: View {
    @StateObject var authFlowManager = AuthFlowManager() // The single source of truth for the auth flow

    var body: some View {
        // Use NavigationStack for multi-step flow
        NavigationStack {
            Group {
                switch authFlowManager.currentStep {
                case .mobileRegistration:
                    CreateAccountView() // Your initial mobile number entry screen
                case .otpVerification:
                    VerifyPhonePageView() // OTP entry and verification
                case .usernameEntry:
                    UsernameView() // Username creation and check
                case .dobEntry:
                    DateOfBirthView() // Date of birth entry
                case .createPassword:
                    CreatePasswordPageView() // Password creation and final registration
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



@main
struct GuChat_UIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(sharedModelContainer)
    }
}

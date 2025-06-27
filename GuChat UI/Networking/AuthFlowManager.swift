import SwiftUI
import Combine

@MainActor
class AuthFlowManager: ObservableObject{
    // Enum to define the steps in the registration and login flow
    enum CurrentStep: String, CaseIterable, Identifiable{
        case entryPage
        case mobileRegistration // Step 1: Enter mobile, request OTP
        case otpVerificationRegister   // otpVerification`
        case otpVerificationReset      // For reset password flow
        case usernameEntry      // Step 3: Enter username, check availability
        case dobEntry           // Step 4: Enter Date of Birth
        case createPassword     // Step 5: Create password, final registration
        case resetPassword          // For resetting password after OTP
        case login              // Separate path for direct login
        case authenticated      // User is fully authenticated and logged in

        var id: String {self.rawValue}
    }
    
    @Published var currentStep: CurrentStep // Tracks the current screen/stage
    @Published var mobileNumber: String = "" // Data collected through the flow
    @Published var countryCode: String = "+61" // Selected country dial code
    @Published var countryFlag: String = "🇦🇺" // Selected country flag
    @Published var otp: String = ""
    @Published var username: String = ""
    @Published var dateOfBirth: Date?
    @Published var password: String = ""
    @Published var confirmPassword: String = "" // For password confirmation
    
    // Loading and error states
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var usernameCheckError: String? = nil // Specific error for username check
    
    private var cancellables = Set<AnyCancellable>()
    private var usernameCheckTask: Task<Void, Never>? // To debounce username checks
    
    init(){
        // Initialize the flow: if a token exists, go to authenticated state
        if APIManager.shared.authToken != nil {
            _currentStep = Published(initialValue: .authenticated)
        } else {
            _currentStep = Published(initialValue: .entryPage)
        }
        
        // Observe changes in APIManager's auth token
        APIManager.shared.$authToken
            .sink { [weak self]  token in
                DispatchQueue.main.async{
                    if token != nil && self?.currentStep != .authenticated{
                        self?.currentStep = .authenticated   // Transition to authenticated if token appears
                    } else if token == nil && self?.currentStep == .authenticated{
                        self?.resetFlow()
                    }
                }
            }
            .store(in: &cancellables)
        
        // Observe username changes for availability check with debounce
        $username
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Wait 0.5s after last change
            .removeDuplicates() // Only react if username actually changed
            .sink { [weak self] newUsername in
                guard let self = self else { return }
                // Only perform check if it's during username entry, not when loading/resetting
                if self.currentStep == .usernameEntry && !newUsername.isEmpty {
                    self.checkUsernameAvailability()
                } else if newUsername.isEmpty {
                    self.usernameCheckError = nil // Clear error if username becomes empty
                }
            }
            .store(in: &cancellables)
    }
    
    
    func resetFlow(){
        mobileNumber = ""
        countryCode = "+61"
        countryFlag = "🇦🇺"
        otp = ""
        username = ""
        dateOfBirth = nil
        password = ""
        confirmPassword = ""
        isLoading = false
        errorMessage = nil
        usernameCheckError = nil
        currentStep = .mobileRegistration // Go back to start
        APIManager.shared.logout() // Ensure APIManager clears its token
    }
    
    // API Call actions
    
    private func checkUsernameAvailability() {
        usernameCheckTask?.cancel()             // cancel previous checks if user is still typing
        
        guard !username.isEmpty else {
            usernameCheckError = nil
            return
        }
        
        isLoading = true
        usernameCheckError = nil // Clear any previous error
        usernameCheckTask = Task{
            do {
                let response = try await APIManager.shared.checkUsernameAvailability(username: username)
                DispatchQueue.main.async {
                    self.isLoading = false
                    if !response.isAvailable{
                        self.usernameCheckError = response.message ?? "Username already exists."
                    } else{
                        self.usernameCheckError = nil // Its available
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.usernameCheckError = error.localizedDescription
                }
            }
        }
    }
    
    func requestOTP(forReset: Bool = false) async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await APIManager.shared.requestOTP(mobileNumber: mobileNumber)
            DispatchQueue.main.async {
                self.isLoading = false
                self.currentStep = forReset ? .otpVerificationReset : .otpVerificationRegister // advance to the OTP Verification
            }
        } catch {
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // OTP Verification
    func verifyOTP() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIManager.shared.verifyOTP(mobileNumber: mobileNumber, otp: otp)
            DispatchQueue.main.async {
                self.isLoading = false
                if response.success {
                    if self.currentStep == .otpVerificationRegister {
                        self.currentStep = .usernameEntry
                    } else if self.currentStep == .otpVerificationReset {
                            self.currentStep = .resetPassword
                        }
                } else {
                    self.errorMessage = response.message ?? "OTP Verification Failed. Please try again."
                }
            }
        } catch {
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Navigate from Username to DOB (this is UI navigation, not an API call)
    func proceedFromUsername() {
        if username.isEmpty || usernameCheckError != nil {
            errorMessage = "Please enter a valid and available username."
            return
        }
        currentStep = .dobEntry
        errorMessage = nil // Clear any general error
    }
    
    // Navigate from DOB to Create Password (this is UI navigation, not an API call)
    func proceedFromDateOfBirth() {
        guard dateOfBirth != nil else {
            errorMessage = "Please select your date of birth."
            return
        }
        currentStep = .createPassword
        errorMessage = nil
    }
    
    // Final Registration Step: Create Password
    func register() async {
        isLoading = true
        errorMessage = nil
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            isLoading = false
            return
        }
        guard password.count >= 6 else { // Basic password policy
            errorMessage = "Password must be at least 6 characters long."
            isLoading = false
            return
        }
        guard let dob = dateOfBirth else { // Should not happen if flow is correct
            errorMessage = "Date of Birth is missing."
            isLoading = false
            return
        }
        
        do {
            _ = try await APIManager.shared.registerUser(mobileNumber: mobileNumber, username: username, dateOfBirth: dob, password: password)
            DispatchQueue.main.async{
                self.isLoading = false
                self.currentStep = .authenticated // Registration Complete, user is logged in
                
                // clear the sensitive date after successful registration
                self.password = ""
                self.confirmPassword = ""
                self.otp = ""
            }
        } catch {
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await APIManager.shared.login(mobileNumber: mobileNumber, password: password)
            DispatchQueue.main.async{
                self.isLoading = false
                self.currentStep = .authenticated // Login Successful
                // Clear sensitive data
                self.password = ""
            }
        } catch {
            DispatchQueue.main.async{
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
}

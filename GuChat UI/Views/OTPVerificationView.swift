import SwiftUI

struct OTPVerificationView: View {
    @State private var digit1 = ""
    @State private var digit2 = ""
    @State private var digit3 = ""
    @State private var digit4 = ""
    
    @EnvironmentObject var authFlowManager: AuthFlowManager
    
    @FocusState private var focusedField: Int?
    
    private func updateOTP() {
           authFlowManager.otp = digit1 + digit2 + digit3 + digit4
       }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        authFlowManager.currentStep = .mobileRegistration
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Text("Verify Phone")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text("Enter the verification code sent to your phone number")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                
                HStack(spacing: 15) {
                    Spacer()
                    otpTextField(text: $digit1, tag: 0)
                    otpTextField(text: $digit2, tag: 1)
                    otpTextField(text: $digit3, tag: 2)
                    otpTextField(text: $digit4, tag: 3)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                HStack(spacing: 0) {
                    Spacer()
                    Text("Didn't get the code? Tap here to ")
                        .foregroundColor(.gray)
                    Button("resend it") {
                        Task {
                            await authFlowManager.requestOTP() // Resend OTP via AuthFlowManager
                        }
                    }
                    .foregroundColor(.blue)
                    Spacer()
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Spacer()
                
                Button(action: {
                    Task {
                        authFlowManager.otp = digit1 + digit2 + digit3 + digit4
                        await authFlowManager.verifyOTP() // Call AuthFlowManager API method
                    }
                }) {
                    Text(authFlowManager.isLoading ? "Verifying..." : "Verify")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(authFlowManager.otp.count == 4 && !authFlowManager.isLoading ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(authFlowManager.otp.count != 4 || authFlowManager.isLoading)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onChange(of: digit1) { _ in updateOTP() }
            .onChange(of: digit2) { _ in updateOTP() }
            .onChange(of: digit3) { _ in updateOTP() }
            .onChange(of: digit4) { _ in updateOTP() }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    focusedField = 0
                }
            }
        }
    }
    
    @ViewBuilder
    private func otpTextField(text: Binding<String>, tag: Int) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .font(.title2)
            .frame(width: 50, height: 50)
            .multilineTextAlignment(.center)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .focused($focusedField, equals: tag)
            .onChange(of: text.wrappedValue) { newValue in
                let filtered = newValue.filter(\.isWholeNumber)
                
                //  Detect if user pasted multiple digits (e.g., "1234")
                if filtered.count == 4 {
                    digit1 = String(filtered.prefix(1))
                    digit2 = String(filtered.dropFirst(1).prefix(1))
                    digit3 = String(filtered.dropFirst(2).prefix(1))
                    digit4 = String(filtered.dropFirst(3).prefix(1))
                    focusedField = nil // Done
                    return
                }
                
                if filtered.count > 1 {
                    text.wrappedValue = String(filtered.prefix(1))
                } else {
                    text.wrappedValue = filtered
                }

                if filtered.count == 1 {
                    if tag < 3 {
                        focusedField = tag + 1
                    } else {
                        focusedField = nil
                    }
                } else if filtered.isEmpty {
                    if tag > 0 {
                        focusedField = tag - 1
                    }
                }
            }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView().environmentObject(AuthFlowManager())
    }
}



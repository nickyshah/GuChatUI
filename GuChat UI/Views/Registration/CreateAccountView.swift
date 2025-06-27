 import SwiftUI

struct CreateAccountView: View {
    
    @EnvironmentObject var authFlowManager: AuthFlowManager
    @StateObject private var countryVM = CountryCodeViewModel()
    @State private var searchText: String = ""
    
    @State private var agreesToTerms: Bool = false
    @State private var presentCountrySheet: Bool = false
    
    // Validation states
    @State private var showMobileError = false
    @State private var shakeMobile = false
    @State private var shakeButton = false
    @State private var showCheckboxError = false
    @State private var shakeCheckbox = false
    
    private var allCountries: [CPData] {
        if self.searchText.isEmpty {
            return CPData.allCountry
        } else {
            return CPData.allCountry.filter { $0.name.contains(self.searchText) }
        }
    }
    
    private var topCountries: [CPData] {
        let topDialCodes = ["+61", "+1"]
        return CPData.allCountry.filter { topDialCodes.contains($0.dial_code) }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Back button
            HStack {
                NavigationLink(destination: EntryPageView().environmentObject(authFlowManager)) {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Title
            Text("Create account")
                .font(.largeTitle)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Mobile Number")
                    .fontWeight(.medium)
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                
                HStack {
                    Button {
                        self.presentCountrySheet = true
                    } label: {
                        Text("\(authFlowManager.countryFlag) \(authFlowManager.countryCode)")
                            .padding(10)
                            .frame(minWidth: 80, minHeight: 40)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(showMobileError ? Color.red : Color(.systemGray4), lineWidth: 1)
                            )
                            .foregroundColor(.black)
                    }
                    
                    TextField("Enter your mobile number", text: $authFlowManager.mobileNumber)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .frame(minWidth: 150, minHeight: 40)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showMobileError ? Color.red : Color(.systemGray4), lineWidth: 1)
                        )
                        .modifier(ShakeEffect(animatableData: CGFloat(shakeMobile ? 1 : 0)))
                        .onChange(of: authFlowManager.mobileNumber) { _ in
                            if showMobileError {
                                showMobileError = false
                            }
                        }
                }
                .padding(.horizontal, 5)
                
                if showMobileError {
                    Text("Please enter your mobile number")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.leading, 10)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $presentCountrySheet) {
                NavigationStack {
                    List {
                        Section(header: Text("Popular Countries")) {
                            ForEach(topCountries) { country in
                                HStack {
                                    Text(country.flag)
                                    Text(country.name).font(.body)
                                    Spacer()
                                    Text(country.dial_code).foregroundColor(Color(.systemGray3))
                                }
                                .onTapGesture {
                                    authFlowManager.countryFlag = country.flag
                                    authFlowManager.countryCode = country.dial_code
                                    presentCountrySheet = false
                                }
                            }
                        }
                        
                        Section(header: Text("All Countries")) {
                            ForEach(allCountries) { country in
                                HStack {
                                    Text(country.flag)
                                    Text(country.name).font(.body)
                                    Spacer()
                                    Text(country.dial_code).foregroundColor(Color(.systemGray3))
                                }
                                .onTapGesture {
                                    authFlowManager.countryFlag = country.flag
                                    authFlowManager.countryCode = country.dial_code
                                    presentCountrySheet = false
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Your Country Name")
                .presentationDetents([.fraction(0.75)])
            }
            
            // Terms checkbox and text
            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    agreesToTerms.toggle()
                    if showCheckboxError && agreesToTerms {
                        showCheckboxError = false
                    }
                }) {
                    Image(systemName: agreesToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreesToTerms ? .blue : .gray)
                        .font(.title3)
                }
                .modifier(ShakeEffect(animatableData: CGFloat(shakeCheckbox ? 1 : 0)))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(showCheckboxError ? Color.red : Color.clear, lineWidth: 2)
                )
                
                HStack(spacing: 0) {
                    Text("By clicking you agree to ") +
                    Text("[Terms of Service]()")
                        .foregroundStyle(.blue) +
                    Text(" and ") +
                    Text("[Privacy Policy]()")
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            
            if showCheckboxError {
                Text("You must agree to the Terms of Service and Privacy Policy")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 10)
            }
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    var hasError = false
                    
                    if authFlowManager.mobileNumber.isEmpty {
                        showMobileError = true
                        shakeMobile = true
                        hasError = true
                    }
                    if !agreesToTerms {
                        showCheckboxError = true
                        shakeCheckbox = true
                        hasError = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shakeMobile = false
                        shakeCheckbox = false
                        shakeButton = false
                    }
                    
                    if hasError {
                        shakeButton = true
                        return
                    }
                    
                    Task {
                        await authFlowManager.requestOTP()
                    }
                }) {
                    Text(authFlowManager.isLoading ? "Sending OTP..." : "Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .modifier(ShakeEffect(animatableData: CGFloat(shakeButton ? 1 : 0)))
                
                if let errorMessage = authFlowManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: LoginPageView().environmentObject(authFlowManager)) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(minWidth: 150, minHeight: 50)
                        .background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            countryVM.load()
            if authFlowManager.countryCode == "+61" && authFlowManager.countryFlag == "🇦🇺" && authFlowManager.mobileNumber.isEmpty {
                if let australia = CPData.allCountry.first(where: { $0.name == "Australia" }) {
                    authFlowManager.countryCode = australia.dial_code
                    authFlowManager.countryFlag = australia.flag
                }
            }
        }
    }
}

// Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView().environmentObject(AuthFlowManager())
        }
    }
}

import SwiftUI

struct LoginPageView: View {
    @State private var rememberMe: Bool = false
    @State private var showingPassword: Bool = false
    @State private var searchText : String = ""
    @State private var presentCountrySheet: Bool = false
    
    @EnvironmentObject var authFlowManager: AuthFlowManager
    
    private var allCountries: [CPData]{
        if self.searchText.isEmpty {
            return CPData.allCountry
        } else {
            return CPData.allCountry.filter{
                $0.name.contains(self.searchText)
            }
        }
        
    }
    
    private var topCountries: [CPData] {
        let topDialCodes = ["+61", "+1"] // Example top countries: Australia, India, US
        return CPData.allCountry.filter { topDialCodes.contains($0.dial_code) }
    }

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Button(action: {
                        authFlowManager.currentStep = .mobileRegistration // Go back to registration start
                        authFlowManager.errorMessage = nil // Clear error
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
                Text("Login")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 30)

                    // Form Fields
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Mobile Number")
                            .fontWeight(.bold)
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                        
                        HStack{
                            Button{
                                self.presentCountrySheet = true
                            }label: {
                                Text("\(authFlowManager.countryFlag) \(authFlowManager.countryCode)")
                                    .padding(10)
                                    .frame(minWidth:80, minHeight: 40)
                                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .foregroundColor(.black)
                            }
                            TextField("Enter Mobile Number", text: $authFlowManager.mobileNumber)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .frame(minWidth:150, minHeight: 40)
                                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                        }
                    
                    

                    Text("Password")
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                        .foregroundColor(.black)

                    HStack {
                        if showingPassword {
                            TextField("Enter password", text: $authFlowManager.password)
                                .foregroundColor(.black)
                        } else {
                            SecureField("Enter password", text: $authFlowManager.password)
                                .foregroundColor(.black)
                        }

                        Button(action: {
                            showingPassword.toggle()
                        }) {
                            Image(systemName: showingPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                    // Remember Me + Forgot Password
                    HStack {
                        Toggle(isOn: $rememberMe) {
                            Text("Remember me")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .foregroundColor(.gray)

                        Spacer()

                        Button(action: {
//                            Action is required to enter
                            print("Forgot password tapped")
                        }) {
                            Text("Forgot password?")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 5)
                        
                        if let errorMessage = authFlowManager.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 4)
                        }
                }
                .padding(.horizontal)

                Spacer()

                //  Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        Task{ await authFlowManager.login() }
                    }) {
                        Text(authFlowManager.isLoading ? "Logging in..." : "Login")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                        RoundedRectangle(cornerRadius: 10).fill(
                                            (authFlowManager.mobileNumber.isEmpty || authFlowManager.password.isEmpty || authFlowManager.isLoading)
                                                ? Color.gray : Color.blue )
                                    )

                    }
                    .disabled(authFlowManager.mobileNumber.isEmpty || authFlowManager.password.isEmpty || authFlowManager.isLoading)

                    Button {
                            authFlowManager.currentStep = .mobileRegistration
                        } label: {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .font(.title2)
                                .foregroundColor(.black)
                                .frame(minHeight: 50)
                                .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $presentCountrySheet) {
                NavigationStack {
                    List {
                        // Section for Top 3 Countries
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

                        // Section for All Filtered Countries
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

        }
    }

// Checkbox Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                    .font(.title3)
                configuration.label
            }
        }
    }
}

// Preview
struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView().environmentObject(AuthFlowManager())
//            .preferredColorScheme(.light)
    }
}

import SwiftUI

struct LoginPageView: View {
    @EnvironmentObject var authFlowManager: AuthFlowManager

    @State private var rememberMe: Bool = false
    @State private var showingPassword: Bool = false
    @State private var searchText: String = ""
    @State private var presentCountrySheet: Bool = false

    @State private var showMobileError = false
    @State private var showPasswordError = false
    @State private var shakeMobile = false
    @State private var shakePassword = false

    private var allCountries: [CPData] {
        searchText.isEmpty
            ? CPData.allCountry
            : CPData.allCountry.filter { $0.name.contains(searchText) }
    }

    private var topCountries: [CPData] {
        let topDialCodes = ["+61", "+1"]
        return CPData.allCountry.filter { topDialCodes.contains($0.dial_code) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 30)

            VStack(alignment: .leading, spacing: 10) {
                Text("Mobile Number")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)

                HStack {
                    Button {
                        presentCountrySheet = true
                    } label: {
                        Text("\(authFlowManager.countryFlag) \(authFlowManager.countryCode)")
                            .padding(10)
                            .background(Color.white)
                            .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showMobileError ? Color.red : Color(.systemGray4), lineWidth: 1)
                            )
                            .foregroundColor(.black)
                    }

                    TextField("Enter Mobile Number", text: $authFlowManager.mobileNumber)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(showMobileError ? Color.red : Color(.systemGray4), lineWidth: 1)
                        )
                        .modifier(ShakeEffect(animatableData: CGFloat(shakeMobile ? 1 : 0)))
                        .onChange(of: authFlowManager.mobileNumber) { newValue in
                            if !newValue.isEmpty {
                                showMobileError = false
                            }
                        }
                }

                if showMobileError {
                    Text("Please enter your mobile number")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Text("Password")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)

                HStack {
                    if showingPassword {
                        TextField("Enter password", text: $authFlowManager.password)
                            .foregroundColor(.black)
                    } else {
                        SecureField("Enter password", text: $authFlowManager.password)
                            .foregroundColor(.black)
                    }

                    Button {
                        showingPassword.toggle()
                    } label: {
                        Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(showPasswordError ? Color.red : Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(8)
                .modifier(ShakeEffect(animatableData: CGFloat(shakePassword ? 1 : 0)))
                .onChange(of: authFlowManager.password) { newValue in
                    if !newValue.isEmpty {
                        showPasswordError = false
                    }
                }

                if showPasswordError {
                    Text("Please enter your password")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember me")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(.gray)

                    Spacer()

                    Button {
                        if authFlowManager.mobileNumber.isEmpty {
                            showMobileError = true
                            shakeMobile = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                shakeMobile = false
                            }
                            return}
                        Task{
                            let success = await authFlowManager.requestOTP(forReset: true)
                        }
                    } label: {
                        Text("Forgot password?")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 15) {
                Button {
                    withAnimation {
                        if authFlowManager.mobileNumber.isEmpty {
                            showMobileError = true
                            shakeMobile = true
                        } else {
                            showMobileError = false
                        }

                        if authFlowManager.password.isEmpty {
                            showPasswordError = true
                            shakePassword = true
                        } else {
                            showPasswordError = false
                        }
                    }

                    if !authFlowManager.mobileNumber.isEmpty && !authFlowManager.password.isEmpty {
                        Task {
                            await authFlowManager.login()
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        shakeMobile = false
                        shakePassword = false
                    }
                } label: {
                    Text(authFlowManager.isLoading ? "Logging in..." : "Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(authFlowManager.isLoading)

                NavigationLink(destination: CreateAccountView().environmentObject(authFlowManager)) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $presentCountrySheet) {
            countrySelectionSheet
        }
    }

    var countrySelectionSheet: some View {
        NavigationStack {
            List {
                Section(header: Text("Popular Countries")) {
                    ForEach(topCountries) { country in
                        countryRow(country)
                    }
                }

                Section(header: Text("All Countries")) {
                    ForEach(allCountries) { country in
                        countryRow(country)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Your Country Name")
        .presentationDetents([.fraction(0.75)])
    }

    func countryRow(_ country: CPData) -> some View {
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

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
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
    }
}

import SwiftUI

struct LoginPageView: View {
    @State private var mobileNumber: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showingPassword: Bool = false

    @State private var selectedCountryCode: String = "+61" // Default to Australia

    let availableCountryCodes = ["+61 Australia", "+1 United States", "+44 United Kingdom"]

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Top Bar
                HStack {
                    NavigationLink(destination: EntryPageView()) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

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

                    HStack(spacing: 10) {
                        // Country Code Menu
                        Menu {
                            ForEach(availableCountryCodes, id: \.self) { code in
                                Button(action: {
                                    if let spaceIndex = code.firstIndex(of: " ") {
                                        selectedCountryCode = String(code[..<spaceIndex])
                                    } else {
                                        selectedCountryCode = code
                                    }
                                }) {
                                    Text(code)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .frame(width: 28, height: 18)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .foregroundColor(.gray)

                                Text(selectedCountryCode)
                                    .foregroundColor(.black)

                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }

                        // Mobile Number Input
                        ZStack(alignment: .leading) {
                            if mobileNumber.isEmpty {
                                Text("Enter mobile number")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)
                            }

                            TextField("", text: $mobileNumber)
                                .keyboardType(.numberPad)
                                .foregroundColor(.black)
                                
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }

                    Text("Password")
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                        .foregroundColor(.black)

                    HStack {
                        if showingPassword {
                            TextField("Enter password", text: $password)
                                .foregroundColor(.black)
                        } else {
                            SecureField("Enter password", text: $password)
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
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

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
                }
                .padding(.horizontal)

                Spacer()

                //  Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
//                        verification needs to be done for login
                        print("Login tapped")
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        print("Create account tapped")
                    }) {
                        Text("Create account")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onTapGesture {
#if canImport(UIKit)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
            }
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
        LoginPageView()
            .preferredColorScheme(.light)
    }
}

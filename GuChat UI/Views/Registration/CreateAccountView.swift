import SwiftUI

struct CreateAccountView: View {
    @State private var mobileNumber: String = ""
    @State private var agreesToTerms: Bool = false
    @Environment(\.dismiss) private var dismiss

    let availableCountryCodes = ["+61 Australia", "+1 United States", "+44 United Kingdom"]
    @State private var selectedCountryCode: String = "+61" // Default to Australia

    var body: some View {
        VStack(spacing: 20) {

            // Back button
            HStack {
                NavigationLink(destination: EntryPageView()) {
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

                    // Mobile Number
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
            }
            .padding(.horizontal)

            // Terms checkbox and text with links — no + concatenation, use HStack + Buttons + Text
            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    agreesToTerms.toggle()
                }) {
                    Image(systemName: agreesToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreesToTerms ? .blue : .gray)
                        .font(.title3)
                }

                HStack(spacing: 0) {
                    Text("By clicking you agree to ")
                        .font(.footnote)
                        .font(.system(size: 32))
                        .fontWeight(.medium)

                    Button(action: {
                        print("Tapped Terms of Service")
                        // TO-DO Link to the terms of service
                    }) {
                        Text("Terms of Service")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle()) // Makes the button appear as plain text

                    Text(" and ")
                        .font(.footnote)

                    Button(action: {
                        print("Tapped Privacy Policy")
                        // TODO: Link to the privacy policy (e.g., open a URL or navigate to a new view)
                    }) {
                        Text("Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle()) // Makes the button appear as plain text
                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true) // Helps the scaling work correctly by not fixing horizontal size

            }
            .padding(.horizontal)
            Text("------------------or------------------")
                .foregroundColor(.gray)
                .padding(.vertical, 10)

            Button("Create account with Email address") {
                // Action required
            }
            .font(.headline)
            .foregroundColor(.blue)

            Spacer()

            VStack(spacing: 15) {
                Button(action: {
                    print("Create account tapped with mobile: \(mobileNumber), agreed: \(agreesToTerms)")
                }) {
                    Text("Create account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(agreesToTerms && !mobileNumber.isEmpty ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!agreesToTerms || mobileNumber.isEmpty)

                Button("Login") {
                    print("Login tapped")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

// SwiftUI Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView()
        }
    }
}

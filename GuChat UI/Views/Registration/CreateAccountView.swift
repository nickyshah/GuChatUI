import SwiftUI

struct CreateAccountView: View {
    @StateObject private var countryVM = CountryCodeViewModel()
    @State private var selectedCode: CountryCode?
    @State private var mobileNumber: String = ""
    @State private var agreesToTerms: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Back button
            HStack {
                Button(action: { dismiss() }) {
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
            
            // Loading/Error state
            Group {
                if countryVM.isLoading && countryVM.codes.isEmpty {
                    ProgressView("Loading country codes...")
                } else if let error = countryVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            
            // Mobile number section
            VStack(alignment: .leading, spacing: 10) {
                Text("Mobile Number")
                    .fontWeight(.medium)
                    .font(.system(size: 22))
                
                HStack(spacing: 10) {
                    // Country Code Picker
                    Menu {
                        ForEach(countryVM.codes) { code in
                            Button(action: {
                                selectedCode = code
                            }) {
                                HStack(spacing: 12) {
                                    Text(code.flag)
                                        .frame(width: 30)
                                    Text(code.dialCode)
                                        .frame(width: 50, alignment: .leading)
                                    Text(code.name)
                                        .frame(minWidth: 150, alignment: .leading)
                                        .lineLimit(1)
                                }
                                .frame(width: 250)
                                .contentShape(Rectangle())
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(selectedCode?.flag ?? "🌐")
                            Text(selectedCode?.dialCode ?? "+1")
                            Image(systemName: "chevron.down")
                                .imageScale(.small)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .frame(width: 120)
                    
                    // Mobile Number Field
                    TextField("Phone number", text: $mobileNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
            
            // Terms and Policies
            HStack(alignment: .center, spacing: 8) {
                Button(action: { agreesToTerms.toggle() }) {
                    Image(systemName: agreesToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreesToTerms ? .blue : .gray)
                }
                
                Text("I agree to the ") +
                Text("Terms").underline().foregroundColor(.blue) +
                Text(" and ") +
                Text("Privacy Policy").underline().foregroundColor(.blue)
            }
            .font(.footnote)
            .padding(.horizontal)
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 15) {
                Button(action: {
                    print("Creating account with: \(selectedCode?.dialCode ?? "") \(mobileNumber)")
                }) {
                    Text("Create account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background((agreesToTerms && !mobileNumber.isEmpty && selectedCode != nil) ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!agreesToTerms || mobileNumber.isEmpty || selectedCode == nil)
                
                Button("Login") {
                    print("Login tapped")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.blue)
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
        .onAppear {
            countryVM.load()
            if selectedCode == nil {
                selectedCode = countryVM.codes.first(where: { $0.countryCode == "US" }) ?? countryVM.codes.first
            }
        }
    }
}

struct CountryCodeRow: View {
    let code: CountryCode
    
    var body: some View {
        HStack(spacing: 12) {
            Text(code.flag)
                .frame(width: 30)
            Text(code.dialCode)
                .frame(width: 50, alignment: .leading)
            Text(code.name)
                .frame(minWidth: 150, alignment: .leading)
                .lineLimit(1)
        }
        .frame(width: 350)
        .contentShape(Rectangle())
    }
}

#Preview{
  CreateAccountView()
}



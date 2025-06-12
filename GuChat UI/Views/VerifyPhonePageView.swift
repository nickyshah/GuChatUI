import SwiftUI

struct VerifyPhonePageView: View {
    @State private var digit1 = ""
    @State private var digit2 = ""
    @State private var digit3 = ""
    @State private var digit4 = ""
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        print("Back button tapped")
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
                    Text("resend it.")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            print("Resend code tapped")
                        }
                    Spacer()
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Spacer()
                
                Button {
                    let code = digit1 + digit2 + digit3 + digit4
                    print("Entered code: \(code)")
                } label: {
                    Text("Verify")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all))
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
                let filtered = newValue.filter { $0.isWholeNumber }
                
                if filtered != newValue {
                    DispatchQueue.main.async {
                        text.wrappedValue = filtered
                    }
                    return
                }
                
                if filtered.count > 1 {
                    DispatchQueue.main.async {
                        text.wrappedValue = String(filtered.prefix(1))
                    }
                    return
                }
                
                if filtered.count == 1 {
                    if tag < 3 {
                        DispatchQueue.main.async {
                            focusedField = tag + 1
                        }
                    } else {
                        DispatchQueue.main.async {
                            focusedField = nil
                        }
                    }
                }
                
                if filtered.isEmpty {
                    if tag > 0 {
                        DispatchQueue.main.async {
                            focusedField = tag - 1
                        }
                    }
                }
            }
    }
}

struct VerifyPhonePageView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyPhonePageView()
    }
}

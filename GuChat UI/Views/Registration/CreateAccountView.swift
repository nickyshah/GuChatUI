import SwiftUI

struct CreateAccountView: View {
    @State private var agreesToTerms: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var navigate = false

    @State private var mobileNumber: String = ""
    @State private var countryCode : String = "+61"
    @State private var countryFlag : String = "🇦🇺"
    @State private var searchText : String = ""
    @State private var presentCountrySheet: Bool = false
    
    private var allCountries: [CPData]{
        if self.searchText.isEmpty {
            return CPData.allCountry
        } else {
            return CPData.allCountry.filter{
                $0.name.contains(self.searchText)
            }
        }
        
    }
    
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
                
                HStack{
                    Button{
                        print("Open Country Picker ")
                        self.presentCountrySheet = true
                    }label: {
                        Text("\(countryFlag) \(countryCode)")
                            .padding(10)
                            .frame(minWidth:80, minHeight: 40)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .foregroundColor(.black)
                    }
                    TextField("Enter your mobile number", text: $mobileNumber)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .frame(minWidth:150, minHeight: 40)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(.horizontal, 5)
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $presentCountrySheet){
               NavigationStack{
                    List(allCountries) {
                        model in
                        HStack{
                            Text(model.flag)
                            Text(model.name).font(.body)
                            Spacer()
                            Text(model.dial_code).foregroundColor(Color(.systemGray3))
                        }
                        .onTapGesture {
                            self.countryFlag = model.flag
                            self.countryCode = model.dial_code
                            self.presentCountrySheet = false
                        }
                    }
               }
               .searchable(text: $searchText,  prompt: "Your Country Name")
               .presentationDetents([.fraction(0.77)])
            }

            // Terms checkbox and text with links — no + concatenation, use HStack + Buttons + Text
            HStack(alignment: .center, spacing: 8) {
                Button(action: {
                    agreesToTerms.toggle()
                }) {
                    Image(systemName: agreesToTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(agreesToTerms ? .blue : .gray)
                        .font(.title3)
                }
                
                HStack(spacing:0){
                    Text("By clicking you agree to ") +
                    Text("[Terms of Service]()")
                        .foregroundStyle(.blue) +
                    Text(" and ") +
                    Text("[Privacy Policy]()")
                        .foregroundStyle(.blue)
                }
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

                
                NavigationLink(destination: LoginPageView()) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(minWidth:150, minHeight: 50)
                        .background(Color(.systemGray4), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
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

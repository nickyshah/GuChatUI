import SwiftUI

struct CreateAccountView: View {
    
    @EnvironmentObject var authFlowManager: AuthFlowManager // <-- Add this
    @StateObject private var countryVM = CountryCodeViewModel() // Keep ViewModel for countries
    @State private var searchText : String = ""
    
    @State private var agreesToTerms: Bool = false
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
    
    private var topCountries: [CPData] {
        let topDialCodes = ["+61", "+1"] // Example top countries: Australia, US
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
                
                HStack{
                    Button{
                        print("Open Country Picker ")
                        self.presentCountrySheet = true
                    }label: {
                        Text("\(authFlowManager.countryFlag) \(authFlowManager.countryCode)")
                            .padding(10)
                            .frame(minWidth:80, minHeight: 40)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .foregroundColor(.black)
                    }
                    TextField("Enter your mobile number", text: $authFlowManager.mobileNumber)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .frame(minWidth:150, minHeight: 40)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(.horizontal, 5)
                
            }
            .padding(.horizontal)
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
            Spacer()

            VStack(spacing: 15) {
                Button(action: {
                    Task{
                        await authFlowManager.requestOTP()
                    }
                }) {
                    Text(authFlowManager.isLoading ? "Sending OTP..." : "Create account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(agreesToTerms && !authFlowManager.mobileNumber.isEmpty && !authFlowManager.isLoading ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!agreesToTerms || authFlowManager.mobileNumber.isEmpty || authFlowManager.isLoading)

                
                // Display general error message
                if let errorMessage = authFlowManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: LoginPageView().environmentObject(authFlowManager)) {
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
        .onAppear {
            countryVM.load() // Load country codes when view appears
            // Set default selected code to Australia if available and not already set
            if authFlowManager.countryCode == "+61" && authFlowManager.countryFlag == "🇦🇺" && authFlowManager.mobileNumber.isEmpty {
                 if let australia = CPData.allCountry.first(where: { $0.name == "Australia" }) {
                     authFlowManager.countryCode = australia.dial_code
                     authFlowManager.countryFlag = australia.flag
                 }
            }
        }
    }
    
}

// SwiftUI Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView().environmentObject(AuthFlowManager())
        }
    }
}

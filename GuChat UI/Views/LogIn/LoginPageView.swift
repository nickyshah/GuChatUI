import SwiftUI

struct LoginPageView: View {
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showingPassword: Bool = false

    @State private var selectedCountryCode: String = "+61" // Default to Australia
    let availableCountryCodes = ["+61 Australia", "+1 United States", "+44 United Kingdom"]
    
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
                            TextField("Enter Mobile Number", text: $mobileNumber)
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
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(minWidth:150, minHeight: 50)
                            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(Color.white.edgesIgnoringSafeArea(.all))
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
//            .preferredColorScheme(.light)
    }
}

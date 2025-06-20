//import SwiftUI
//import Combine
//
//class PhoneNumberViewModel: ObservableObject {
//    // Input Properties
//    @Published var searchCountry: String = ""
//    @Published var mobPhoneNumber: String = ""
//    @Published var selectedCountry: CPData
//    
//    // UI State
//    @Published var presentSheet = false
//    @FocusState private var KeyIsFocused: Bool
//    
//    // Available countries
//    private let allCountries: [CPData]
//    var filteredCountries: [CPData] {
//        if searchCountry.isEmpty {
//            return allCountries
//        } else {
//            return allCountries.filter {
//                $0.name.localizedCaseInsensitiveContains(searchCountry) ||
//                $0.dial_code.localizedCaseInsensitiveContains(searchCountry) ||
//                $0.code.localizedCaseInsensitiveContains(searchCountry)
//            }
//        }
//    }
//    
//    init() {
//        self.allCountries = CPData.allCountry
//        self.selectedCountry = CPData.example
//    }
//    
//    // Format phone number based on selected country's pattern
//    func formatPhoneNumber() {
//        var pureNumber = mobPhoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
//        
//        for index in 0..<selectedCountry.pattern.count {
//            guard index < pureNumber.count else {
//                mobPhoneNumber = pureNumber
//                return
//            }
//            
//            let stringIndex = String.Index(utf16Offset: index, in: selectedCountry.pattern)
//            let patternCharacter = selectedCountry.pattern[stringIndex]
//            guard patternCharacter != "#" else { continue }
//            pureNumber.insert(patternCharacter, at: stringIndex)
//        }
//        
//        mobPhoneNumber = pureNumber
//    }
//    
//    // Validation
//    var isValidPhoneNumber: Bool {
//        let pureNumber = mobPhoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
//        return pureNumber.count >= 7 // Minimum phone number length
//    }
//    
//    // Select a new country
//    func selectCountry(_ country: CPData) {
//        selectedCountry = country
//        presentSheet = false
//        searchCountry = ""
//        formatPhoneNumber() // Reformat number with new pattern
//    }
//}
//
//struct PhoneNumberView: View {
//    @StateObject private var viewModel = PhoneNumberViewModel()
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        GeometryReader { geo in
//            let hasHomeIndicator = geo.safeAreaInsets.bottom > 0
//            NavigationStack {
//                VStack {
//                    // Header
//                    Text("Confirm country code and enter phone number")
//                        .multilineTextAlignment(.center)
//                        .font(.title).bold()
//                        .padding(.top, hasHomeIndicator ? 70 : 20)
//                    
//                    // Phone Input
//                    HStack {
//                        // Country Code Button
//                        Button {
//                            viewModel.presentSheet = true
//                            viewModel.keyIsFocused = false
//                        } label: {
//                            Text("\(viewModel.selectedCountry.flag) \(viewModel.selectedCountry.dial_code)")
//                                .padding(10)
//                                .frame(minWidth: 80, minHeight: 47)
//                                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                                .foregroundColor(foregroundColor)
//                        }
//                        
//                        // Phone Number Field
//                        TextField("", text: $viewModel.mobPhoneNumber)
//                            .placeholder(when: viewModel.mobPhoneNumber.isEmpty) {
//                                Text("Phone number")
//                                    .foregroundColor(.secondary)
//                            }
//                            .focused($viewModel.keyIsFocused)
//                            .keyboardType(.numbersAndPunctuation)
//                            .onReceive(Just(viewModel.mobPhoneNumber)) { _ in
//                                viewModel.formatPhoneNumber()
//                            }
//                            .padding(10)
//                            .frame(minWidth: 80, minHeight: 47)
//                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
//                    }
//                    .padding(.top, 20)
//                    .padding(.bottom, 15)
//                    
//                    // Next Button
//                    Button {
//                        // Handle next action
//                        print("Phone number: \(viewModel.selectedCountry.dial_code) \(viewModel.mobPhoneNumber)")
//                    } label: {
//                        Text("Next")
//                    }
//                    .disableWithOpacity(!viewModel.isValidPhoneNumber)
//                    .buttonStyle(OnboardingButtonStyle())
//                    
//                    Spacer()
//                }
//                .animation(.easeInOut(duration: 0.6), value: viewModel.keyIsFocused)
//                .padding(.horizontal)
//                .onTapGesture {
//                    hideKeyboard()
//                }
//                .sheet(isPresented: $viewModel.presentSheet) {
//                    countrySelectionSheet
//                }
//            }
//        }
//        .ignoresSafeArea(.keyboard)
//    }
//    
//    // Country Selection Sheet
//    private var countrySelectionSheet: some View {
//        NavigationStack {
//            List(viewModel.filteredCountries) { country in
//                HStack {
//                    Text(country.flag)
//                    Text(country.name)
//                        .font(.body)
//                    Spacer()
//                    Text(country.dial_code)
//                        .foregroundColor(.secondary)
//                }
//                .onTapGesture {
//                    viewModel.selectCountry(country)
//                }
//            }
//            .listStyle(.plain)
//            .searchable(text: $viewModel.searchCountry, prompt: "Search country")
//            .navigationTitle("Select Country")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//        .presentationDetents([.medium, .large])
//    }
//    
//    // UI Helpers
//    private var foregroundColor: Color {
//        colorScheme == .dark ? Color(.white) : Color(.black)
//    }
//    
//    private var backgroundColor: Color {
//        colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)
//    }
//}
//
//// MARK: - Preview
//struct PhoneNumberView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhoneNumberView()
//    }
//}
//
//// MARK: - View Extensions
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content) -> some View {
//            ZStack(alignment: alignment) {
//                placeholder().opacity(shouldShow ? 1 : 0)
//                self
//            }
//        }
//    
//    func hideKeyboard() {
//        let resign = #selector(UIResponder.resignFirstResponder)
//        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
//    }
//    
//    func disableWithOpacity(_ condition: Bool) -> some View {
//        self
//            .disabled(condition)
//            .opacity(condition ? 0.6 : 1)
//    }
//}
//
//struct OnboardingButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .frame(height: 49)
//                .foregroundColor(Color(.systemBlue))
//            
//            configuration.label
//                .fontWeight(.semibold)
//                .foregroundColor(Color(.white))
//        }
//    }
//}

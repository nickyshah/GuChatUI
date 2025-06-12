//import SwiftUI
//
//struct DateOfBirthView: View {
//    @State private var dateOfBirth: String = "" // Use String for TextField input
//    @Environment(\.dismiss) private var dismiss // For dismissing the current view
//
//    @State private var selectedDate: Date = Date()
//    @State private var isDatePickerShowing: Bool = false // To toggle the custom pop-up
//
//    var body: some View {
//        ZStack { // Use ZStack at the root to layer the pop-up on top
//            VStack(spacing: 20) {
//                // Back button row
//                HStack {
//                    Image(systemName: "arrow.backward")
//                        .font(.title2)
//                        .onTapGesture {
//                            dismiss()
//                        }
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//
//                // Title
//                Text("Enter Date of Birth")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//
//                // Date of Birth input section
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Date of Birth")
//                        .font(.headline)
//                        .foregroundColor(.black)
//
//                    HStack {
//                        TextField("dd/mm/yyyy", text: $dateOfBirth) // Placeholder text
//                            .keyboardType(.numbersAndPunctuation)
//                            .autocorrectionDisabled()
//                            .textInputAutocapitalization(.never)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 12)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                            // Disable direct input to force picker usage
//                            .disabled(true)
//                            .onTapGesture { // Tap on TextField also shows picker
//                                isDatePickerShowing = true
//                            }
//
//                        Button(action: {
//                            isDatePickerShowing = true
//                        }) {
//                            Image(systemName: "calendar")
//                                .foregroundColor(.gray)
//                                .font(.title2)
//                                .padding(.trailing, 8)
//                        }
//                    }
//
//                    Text("Make sure the entered information is correct. It won't be visible to anyone else except you.")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                        .padding(.leading, 4)
//                }
//                .padding(.horizontal)
//
//                Spacer() // Pushes content to the top
//
//                // Continue Button
//                Button(action: {
//                    print("Continue with Date of Birth: \(dateOfBirth)")
//                    // In a real app, you'd validate the date and proceed
//                }) {
//                    Text("Continue")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(dateOfBirth.isEmpty ? Color.gray : Color.blue)
//                        .cornerRadius(10)
//                }
//                .disabled(dateOfBirth.isEmpty)
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//            }
//            // Apply these to the main content VStack, not the ZStack for toolbar visibility
//            .navigationBarBackButtonHidden(true)
//            .toolbar(.hidden, for: .navigationBar)
//            .onChange(of: selectedDate) { newDate in
//                // Update dateOfBirth string when selectedDate changes from picker
//                let formatter = DateFormatter()
//                formatter.dateFormat = "dd/MM/yyyy"
//                dateOfBirth = formatter.string(from: newDate)
//            }
//
//            // Custom Pop-up for DatePicker, displayed conditionally
//            if isDatePickerShowing {
//                DatePickerPopUpView(selectedDate: $selectedDate, isShowing: $isDatePickerShowing) { date in
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "dd/MM/yyyy"
//                    dateOfBirth = formatter.string(from: date)
//                }
//                .transition(.opacity) // Add a fade transition for smoother appearance
//            }
//        }
//    }
//}
//
//// Helper View for the DatePicker pop-up
//struct DatePickerPopUpView: View {
//    @Binding var selectedDate: Date
//    @Binding var isShowing: Bool
//    var onDateSelected: (Date) -> Void
//
//    var body: some View {
//        ZStack {
//            // Semi-transparent background that dims the content behind it
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all) // Extends to safe areas
//                .onTapGesture {
//                    // Dismiss the pop-up when tapping outside the white box
//                    isShowing = false
//                }
//
//            // The white pop-up box containing the DatePicker
//            VStack {
//                DatePicker(
//                    "Select Date", // This label is hidden by labelsHidden()
//                    selection: $selectedDate,
//                    displayedComponents: .date
//                )
//                .datePickerStyle(.graphical) // Or .wheel, .compact depending on preference
//                .labelsHidden()
//
//                Divider() // A visual separator between the picker and the button
//
//                Button("Done") {
//                    onDateSelected(selectedDate)
//                    isShowing = false
//                }
//                .padding(.vertical, 8)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(radius: 10)
//            .padding(20)
//        }
//    }
//}
//
//#Preview {
//        DateOfBirthView()
//
//}


import SwiftUI

struct DateOfBirthView: View {
    @State private var dateOfBirth: String = ""
    @State private var selectedDate: Date = Date()
    @State private var isDatePickerShowing: Bool = false
    @State private var navigateToPage1: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    // Back button row
                    HStack {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .onTapGesture {
                                navigateToPage1 = true
                            }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    NavigationLink(destination: UsernameView(), isActive: $navigateToPage1) {}

                    // Title
                    Text("Enter Date of Birth")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Date of Birth input section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date of Birth")
                            .font(.headline)
                            .foregroundColor(.black)

                        HStack {
                            TextField("dd/mm/yyyy", text: $dateOfBirth)
                                .keyboardType(.numbersAndPunctuation)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .disabled(true)
                                .onTapGesture {
                                    isDatePickerShowing = true
                                }

                            Button(action: {
                                isDatePickerShowing = true
                            }) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.gray.opacity(0.4))
                                    .font(.title2)
                                    .scaleEffect(2)
                                    .padding(10)
                            }
                        }

                        Text("Make sure the entered information is correct. It won't be visible to anyone else except you.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 4)
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Continue Button
                    Button(action: {
                        print("Continue with Date of Birth: \(dateOfBirth)")
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(dateOfBirth.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(dateOfBirth.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .onChange(of: selectedDate) { newDate in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    dateOfBirth = formatter.string(from: newDate)
                }

                if isDatePickerShowing {
                    DatePickerPopUpView(selectedDate: $selectedDate, isShowing: $isDatePickerShowing) { date in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        dateOfBirth = formatter.string(from: date)
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}

struct DatePickerPopUpView: View {
    @Binding var selectedDate: Date
    @Binding var isShowing: Bool
    var onDateSelected: (Date) -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowing = false
                }

            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()

                Divider()

                Button("Done") {
                    onDateSelected(selectedDate)
                    isShowing = false
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(20)
        }
    }
}

#Preview {
    DateOfBirthView()
}

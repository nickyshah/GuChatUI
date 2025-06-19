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

//import SwiftUI
//
//struct DateOfBirthView: View {
//    @EnvironmentObject var authFlowManager: AuthFlowManager
//    @State private var isDatePickerShowing: Bool = false
//    @State private var showValidationError: Bool = false
//    @State private var shakeTrigger: Bool = false
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 20) {
//                // Back button
//                HStack {
//                    Button(action: {
//                        authFlowManager.currentStep = .usernameEntry
//                        authFlowManager.errorMessage = nil
//                        showValidationError = false
//                    }) {
//                        Image(systemName: "arrow.backward")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.top, 10)
//
//                // Title
//                Text("Enter Date of Birth")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//
//                // Date input
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Date of Birth")
//                        .font(.headline)
//                        .foregroundColor(.black)
//
//                    HStack {
//                        TextField(showValidationError ? "Please enter your date of birth" : "dd/mm/yyyy", text: Binding(
//                            get: {
//                                if let dob = authFlowManager.dateOfBirth {
//                                    let formatter = DateFormatter()
//                                    formatter.dateFormat = "dd/MM/yyyy"
//                                    return formatter.string(from: dob)
//                                }
//                                return ""
//                            },
//                            set: { _ in }
//                        ))
//                        .keyboardType(.numbersAndPunctuation)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 12)
//                        .background(Color.white)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(showValidationError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
//                        )
//                        .modifier(ShakeEffect(trigger: shakeTrigger))
//                        .disabled(true)
//                        .onTapGesture {
//                            isDatePickerShowing = true
//                        }
//
//                        Button(action: {
//                            isDatePickerShowing = true
//                        }) {
//                            Image(systemName: "calendar")
//                                .foregroundColor(Color.gray.opacity(0.4))
//                                .font(.title2)
//                                .scaleEffect(2)
//                                .padding(10)
//                        }
//                    }
//
//                    Text("Make sure the entered information is correct. It won't be visible to anyone else except you.")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                        .padding(.leading, 4)
//
//                    if showValidationError {
//                        Text("Please enter your date of birth")
//                            .foregroundColor(.red)
//                            .font(.caption)
//                            .padding(.leading, 4)
//                    }
//                }
//                .padding(.horizontal)
//
//                Spacer()
//
//                // Continue Button
//                Button(action: {
//                    if authFlowManager.dateOfBirth == nil {
//                        withAnimation {
//                            shakeTrigger.toggle()
//                            showValidationError = true
//                        }
//                    } else {
//                        showValidationError = false
//                        authFlowManager.proceedFromDateOfBirth()
//                    }
//                }) {
//                    Text("Continue")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .modifier(ShakeEffect(trigger: shakeTrigger))
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//            }
//            .navigationBarBackButtonHidden(true)
//            .background(Color.white.ignoresSafeArea())
//
//            if isDatePickerShowing {
//                DatePickerPopUpView(selectedDate: Binding(
//                    get: { authFlowManager.dateOfBirth ?? Date() },
//                    set: { authFlowManager.dateOfBirth = $0 }
//                ), isShowing: $isDatePickerShowing) { date in
//                    authFlowManager.dateOfBirth = date
//                }
//                .transition(.opacity)
//            }
//        }
//    }
//}
//
//// Shake animation modifier
//struct ShakeEffect: GeometryEffect {
//    var travelDistance: CGFloat = 6
//    var shakesPerUnit = 3
//    var trigger: Bool
//
//    var animatableData: CGFloat {
//        get { trigger ? 1 : 0 }
//        set { }
//    }
//
//    func effectValue(size: CGSize) -> ProjectionTransform {
//        let xTranslation = travelDistance * sin(animatableData * .pi * CGFloat(shakesPerUnit))
//        return ProjectionTransform(CGAffineTransform(translationX: xTranslation, y: 0))
//    }
//}
//
//struct DatePickerPopUpView: View {
//    @Binding var selectedDate: Date
//    @Binding var isShowing: Bool
//    var onDateSelected: (Date) -> Void
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    isShowing = false
//                }
//
//            VStack {
//                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                    .datePickerStyle(.wheel)
//                    .labelsHidden()
//
//                Divider()
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
//                
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
//struct DateOfBirthView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            DateOfBirthView().environmentObject(AuthFlowManager())
//        }
//    }
//}

import SwiftUI

struct DateOfBirthView: View {
    @EnvironmentObject var authFlowManager: AuthFlowManager
    @State private var isDatePickerShowing: Bool = false
    @State private var showValidationError: Bool = false
    @State private var shakeTrigger: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        authFlowManager.currentStep = .usernameEntry
                        authFlowManager.errorMessage = nil
                        showValidationError = false
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Text("Enter Date of Birth")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Date of Birth")
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack {
                        TextField(showValidationError ? "Please enter your date of birth" : "dd/mm/yyyy", text: Binding(
                            get: {
                                if let dob = authFlowManager.dateOfBirth {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd/MM/yyyy"
                                    return formatter.string(from: dob)
                                }
                                return ""
                            },
                            set: { _ in }
                        ))
                        .keyboardType(.numbersAndPunctuation)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(showValidationError ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .modifier(ShakeEffect(animatableData: CGFloat(shakeTrigger ? 1 : 0)))
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

                    if showValidationError {
                        Text("Please enter your date of birth")
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading, 4)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    if authFlowManager.dateOfBirth == nil {
                        withAnimation {
                            shakeTrigger.toggle()
                            showValidationError = true
                        }
                    } else {
                        showValidationError = false
                        authFlowManager.proceedFromDateOfBirth()
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .modifier(ShakeEffect(animatableData: CGFloat(shakeTrigger ? 1 : 0)))
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white.ignoresSafeArea())

            if isDatePickerShowing {
                DatePickerPopUpView(selectedDate: Binding(
                    get: { authFlowManager.dateOfBirth ?? Date() },
                    set: { authFlowManager.dateOfBirth = $0 }
                ), isShowing: $isDatePickerShowing) { date in
                    authFlowManager.dateOfBirth = date
                }
                .transition(.opacity)
            }
        }
    }
}

struct DatePickerPopUpView: View {
    @Binding var selectedDate: Date
    @Binding var isShowing: Bool
    var onDateSelected: (Date) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowing = false
                }

            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
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

struct DateOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DateOfBirthView().environmentObject(AuthFlowManager())
        }
    }
}

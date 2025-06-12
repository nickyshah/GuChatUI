import SwiftUI

struct CreatePasswordPageView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var showingPassword = false
    @State private var showingConfirmPassword = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    NavigationLink(destination: Text("Back Placeholder")) {
                        Image(systemName: "arrow.backward")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Text("Create Password")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 30)

                PasswordInputSection(
                    viewModel: viewModel,
                    showingPassword: $showingPassword,
                    showingConfirmPassword: $showingConfirmPassword
                )
                .padding(.horizontal)

                PasswordRequirementsView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.top, 30)

                Spacer()

                Button(action: {
                    print("Create password: \(viewModel.password)")
                }) {
                    Text("Create")
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
        }
    }
}
#Preview {
    CreatePasswordPageView()
}

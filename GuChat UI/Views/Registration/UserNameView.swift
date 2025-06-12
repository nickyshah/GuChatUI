import SwiftUI

struct UsernameView: View {
    @State private var username: String = ""
    @State private var usernameExists: Bool = false // State to control error message visibility
    @Environment(\.dismiss) private var dismiss // For dismissing the current view
    @State private var goback: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                // Back button row
                HStack {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .onTapGesture {
                            goback = true
                        }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                NavigationLink(destination: CreateAccountView(), isActive: $goback){}
                
                // Title
                Text("Enter username")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Username input section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Username")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    HStack {
                        TextField("Username", text: $username) // Placeholder text
                            .keyboardType(.default)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                        // Apply conditional border color based on usernameExists state
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(usernameExists ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        // Exclamation mark icon if username exists
                        if usernameExists {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(.trailing, 8)
                        }
                    }
                    
                    // Error message if username exists
                    if usernameExists {
                        Text("Username already exists")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 4) // Align with the text field
                    }
                }
                .padding(.horizontal)
                
                Spacer() // Pushes content to the top
                
                // Continue Button
                Button(action: {
                    // Simulate username check logic
                    // In a real app, you would make an API call here
                    if username.lowercased() == "robert jones" { // Example: Simulate existing username
                        usernameExists = true
                    } else {
                        usernameExists = false
                        print("Continue with username: \(username)")
                        // Navigate to the next screen (e.g., password creation)
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(username.isEmpty ? Color.gray : Color.blue) // Disable if username is empty
                        .cornerRadius(10)
                }
                .disabled(username.isEmpty) // Disable button if username is empty
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            // Modern approach to hide navigation bar if this view is pushed onto NavigationStack
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// Xcode Previews
#Preview {
    NavigationStack { // Wrap in NavigationStack for accurate preview
        UsernameView()
    }
}

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                EntryPageView() // Transition to welcome screen
            } else {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    
                    VStack {
                        Image("GuChatWhiteLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

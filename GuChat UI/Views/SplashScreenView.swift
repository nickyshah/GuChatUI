import SwiftUI

struct SplashScreenView: View {
    @State private var showAuthFlow = false

    var body: some View {
        Group {
            if showAuthFlow {
                AuthenticationFlowView() // ✅ now environmentObject works
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
                            showAuthFlow = true
                        }
                    }
                }
            }
        }
    }
}

// SwiftUI Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SplashScreenView().environmentObject(AuthFlowManager())
        }
    }
}


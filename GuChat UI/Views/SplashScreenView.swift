import SwiftUI

struct SplashScreenView: View{
    @State private var isActive = false
    
    var body: some View{
        Group{
            if isActive{
                EntryPageView()
            } else{
                ZStack{
                    Color.blue.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        Image("GuChatWhiteLogo")
                            .resizable()
                            .frame(width: 180 ,height: 180)
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            withAnimation{
                                isActive = true
                            }
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

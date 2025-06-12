import SwiftUI

struct RegistrationPageView: View {
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.white)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("GU_Chat_Blue")
                    
                    
                    HStack{
                        VStack{
                            Text("Welcome")
                                .font(.system(size: 32, weight: .medium, design: .default))
                                .foregroundColor(.black)
                                .padding(.top, 20)
                            
                            Text("Create your profile in GU Chat")
                                .font(.system(size: 24, weight: .light, design: .default))
                                .foregroundColor(.black)
                            
                        }
                        
                    }.padding(.bottom, 20)
                    
                    
                }
            }
        }
    }
 
}

#Preview {
    RegistrationPageView()
}


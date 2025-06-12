import SwiftUI

struct EntryPageView: View {
    
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
                    
                    HStack{
                        VStack{
                            
//                             Navigating to the Registration Page
                            NavigationLink(destination: CreateAccountView()){
                                Text("Create Account")
                                    .frame(width: 360, height: 50)
                                    .font(.system(size: 24))
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            
//                             Navigating to the Login Page
                            NavigationLink(destination: LoginPageView()){
                                Text("LogIn")
                                    .frame(width: 360, height: 50)
                                    .font(.system(size: 24))
                                    .background(Color.gray.opacity(0.4))
                                    .foregroundColor(.black)
                                .cornerRadius(5)}
                            
                        }.padding(.bottom, -10)
                        
                        
                    }.padding(.top, 20)
                }
            }
        }
    }
 
}

#Preview {
    EntryPageView()
}


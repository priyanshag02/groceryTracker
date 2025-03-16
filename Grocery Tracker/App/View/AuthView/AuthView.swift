//
//  SignUpView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var selectedTab: Int
    var authTitle: [String] = ["Login", "Sign Up"]
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var phone: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State var showPassword: Bool = false
    
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 40) {
                ZStack (alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray6))
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 60)
                        .offset(x: selectedTab == 0 ? 0 : UIScreen.main.bounds.width * 0.3)
                        .animation(.spring(duration: 0.3, bounce: 0.3), value: selectedTab)
                    
                    HStack (spacing: 0) {
                        ForEach(0..<authTitle.count, id: \.self) { index in
                            Button {
                                withAnimation (.easeInOut(duration: 0.35)) {
                                    selectedTab = index
                                }
                            } label: {
                                Text("\(authTitle[index])")
                                    .font(.title3)
                                    .fontWeight(selectedTab == index ? .bold : .semibold)
                                    .foregroundStyle(selectedTab == index ? .green.opacity(0.8) : .white)
                                    .frame(width: UIScreen.main.bounds.width * 0.3)
                            }
                        }
                    }
                }
                
                if selectedTab == 0 {
                    LoginView(email: $email, password: $password, selectedTab: $selectedTab, showAlert: $showAlert, alertMessage: $alertMessage, showPassword: $showPassword)
                } else {
                    SignUpView(email: $email, fullName: $fullName, phone: $phone, password: $password, confirmPassword: $confirmPassword, selectedTab: $selectedTab, showAlert: $showAlert, alertMessage: $alertMessage, showPassword: $showPassword)
                }
            }
            .alert (isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text("\(alertMessage)"),
                      dismissButton: .default(Text("Ok")))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.green.opacity(0.7))
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AuthView(selectedTab: 0)
        .environmentObject(AuthViewModel())
}

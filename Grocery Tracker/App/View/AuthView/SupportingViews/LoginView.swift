//
//  LoginView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var selectedTab: Int
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showPassword: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    var isFormValid: Bool {
        return !email.isEmpty && email.contains("@") && password.count >= 8
    }
    
    var body: some View {
        VStack (spacing: 50) {
            VStack(spacing: 8) {
                
                CredentialView(title: "Email", fieldText: "", value: $email)
                ZStack (alignment: .trailing) {
                    if showPassword {
                        CredentialView(title: "Password", fieldText: "\(password)", value: $password)
                            .autocapitalization(.none)
                    } else {
                        PasswordFieldView(title: "Password", fieldText: "8-12 characters", value: $password)
                            .autocapitalization(.none)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .frame(width: 36)
                            .padding(.trailing, 30)
                            .padding(.top, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Button {
                    Task {
                        do {
                            try await authViewModel.resetPassword(withEmail: email)
                            alertMessage = "A password reset email has been sent to \(email). Please check your inbox."
                            showAlert.toggle()
                        }
                        catch {
                            alertMessage = error.localizedDescription
                            showAlert.toggle()
                        }
                    }
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 15)
                }
            }
            .frame(height: 380)

            Button {
                Task {
                    do {
                        try await authViewModel.signIn(email: email, password: password)
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert.toggle()
                    }
                }
            } label: {
                AuthButton(title: "Login", selectedTab: $selectedTab)
                    .disabled(!isFormValid)
            }
            .padding(.vertical, 10)
        }
    }
}

//
//  SignUpView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var email: String
    @Binding var fullName: String
    @Binding var phone: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var selectedTab: Int
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @Binding var showPassword: Bool
    var isFormValid: Bool {
        return !email.isEmpty && email.contains("@") && password.count >= 8 && !fullName.isEmpty && phone.count == 10 && phone.allSatisfy({$0.isNumber})
    }
    
    var body: some View {
        VStack (spacing: 50) {
            VStack(spacing: 8) {
                CredentialView(title: "Email", fieldText: "", value: $email)
                CredentialView(title: "Full Name", fieldText: "", value: $fullName)
                CredentialView(title: "Contact Number", fieldText: "", value: $phone)
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
                ZStack (alignment: .trailing) {
                    PasswordFieldView(title: "Confirm Password", fieldText: "", value: $confirmPassword)
                    if password == confirmPassword && !password.isEmpty && !confirmPassword.isEmpty {
                            Image(systemName: "checkmark.circle")                            .foregroundStyle(.green)
                                .frame(width: 36)
                                .padding(.trailing, 30)
                                .padding(.top, 24)
                    } else {
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            Image(systemName: "xmark.circle")                            .foregroundStyle(.red)
                                .frame(width: 36)
                                .padding(.trailing, 30)
                                .padding(.top, 24)
                        }
                    }
                }
            }
            .frame(height: 380)
            
            Button {
                Task {
                    do {
                        authViewModel.isLoading = true
                        try await authViewModel.createUser(email: email, password: password, fullName: fullName, phone: phone)
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert.toggle()
                    }
                }
            } label: {
                AuthButton(title: "Create account", selectedTab: $selectedTab)
                    .disabled(!isFormValid)
            }
            .padding(.vertical, 10)
        }
    }
}

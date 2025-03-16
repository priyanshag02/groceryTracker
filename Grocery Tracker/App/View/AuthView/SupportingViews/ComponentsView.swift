//
//  ComponentView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import Foundation
import SwiftUI

struct CredentialView: View {
    var title: String
    var fieldText: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(title)")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 40)
            TextField("\(fieldText)", text: $value)
                .autocapitalization(.none)
                .padding(.leading, 25)
                .foregroundStyle(.green)
                .frame(width: 300, height: 50)
                .background(Color(.systemGray6), in: Capsule())
                .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PasswordFieldView: View {
    var title: String
    var fieldText: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(title)")
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 40)
            SecureField("\(fieldText)", text: $value)
                .autocapitalization(.none)
                .padding(.leading, 25)
                .foregroundStyle(.green)
                .frame(width: 300, height: 50)
                .background(Color(.systemGray6), in: Capsule())
                .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AuthButton: View {
    var title: String
    @Binding var selectedTab: Int
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isLoading {
            ProgressView()
                .frame(width: 50)
        } else {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(.green)
                .frame(width: selectedTab == 0 ? 100 : 200, height: 50)
                .background(Color(.systemGray6), in: Capsule())
        }
    }
}

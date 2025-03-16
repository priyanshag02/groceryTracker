//
//  ProfileView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var showDeleteAccountSheet: Bool = false
    @State private var passwordForDeletion: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isError: Bool = true
    @State private var isDeleting: Bool = false
    @Environment(\.dismiss) var dismiss
    @Binding var isSubscribed: Bool
    @Binding var subscriberMode: Int
    
    var body: some View {
        NavigationStack {
            VStack (spacing: isSubscribed ? 90 : 40) {
                if isSubscribed {
                    HStack (spacing: 10) {
                        Text("\(authViewModel.currentUser?.fullName ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.green)
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                            .frame(width: 20)
                            .frame(width: 30, height: 30)
                            .background(.white, in: Circle())
                    }
                    .frame(width: 250)
                } else {
                    VStack (spacing: 15) {
                        Text("\(authViewModel.currentUser?.fullName ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.green.opacity(0.8))
                        NavigationLink (destination: SubscriberView(subscriberMode: $subscriberMode, isSubscribed: $isSubscribed)) {
                            HStack (spacing: 10){
                                Image(systemName: "crown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundStyle(.white)
                                Text("Subscribe")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 150, height: 35)
                            .background(.green.opacity(0.8), in: Capsule())
                        }
                    }
                }
                
                VStack (spacing: 20) {
                    DisclosureGroup {
                        HStack {
                            VStack (alignment: .leading ,spacing: 12) {
                                Text("Email: ")
                                    .font(.headline)
                                    .frame(height: 24)
                                Text("Phone: ")
                                    .font(.headline)
                                    .frame(height: 24)
                            }
                            VStack (alignment: .leading ,spacing: 12) {
                                Text(authViewModel.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .frame(height: 24)
                                    .foregroundStyle(.white)
                                Text(authViewModel.currentUser?.phone ?? "")
                                    .font(.subheadline)
                                    .frame(height: 24)
                                    .foregroundStyle(.white)
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .foregroundStyle(.white)
                    } label: {
                        Text("Contact Info")
                            .font(.headline)
                    }
                    .foregroundStyle(.white)
                    .accentColor(.white)
                    .padding(.horizontal, 10)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white)
                    
                    Button {
                        withAnimation {
                            showDeleteAccountSheet = true
                        }
                    } label: {
                        HStack (spacing: 14){
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.red)
                            Text("Delete Account")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.white)
                    
                    Button {
                        withAnimation {
                            authViewModel.signOut()
                        }
                    } label: {
                        HStack (spacing: 20){
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 9, height: 12)
                            Text("Sign Out")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .opacity(showDeleteAccountSheet ? 0.1 : 1)
            .overlay {
                if showDeleteAccountSheet {
                    VStack(spacing: 20) {
                        Text("Delete Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                        
                        Text("This action cannot be undone. Please enter your password to confirm.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $passwordForDeletion)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .disabled(isDeleting)
                        
                        HStack(spacing: 20) {
                            Button("Cancel") {
                                passwordForDeletion = ""
                                showDeleteAccountSheet = false
                            }
                            .frame(width: 120, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .disabled(isDeleting)
                            
                            Button {
                                Task {
                                    await deleteAccount()
                                }
                            } label: {
                                if isDeleting {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Delete")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 120, height: 40)
                            .background(Color.red)
                            .cornerRadius(8)
                            .disabled(isDeleting)
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(width: 350, height: 300)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
                    .frame(height: 400, alignment: .top)
                }
            }
            .padding(.top, 75)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isError ? "Error" : "Success"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    func deleteAccount() async {
        isDeleting = true
        do {
            try await authViewModel.deleteAccount(password: passwordForDeletion)
            isDeleting = false
            passwordForDeletion = ""
            showDeleteAccountSheet = false
        } catch {
            isDeleting = false
            passwordForDeletion = ""
            alertMessage = "Failed to delete account: \(error.localizedDescription)"
            isError = true
            showAlert = true
            showDeleteAccountSheet = false
        }
    }
}

#Preview {
    ProfileView(isSubscribed: .constant(false), subscriberMode: .constant(0))
        .environmentObject(AuthViewModel())
}

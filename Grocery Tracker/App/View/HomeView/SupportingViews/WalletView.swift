//
//  WalletView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct WalletView: View {
    @Binding var budget: String
    @Binding var showMoneyAdd: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 40) {
                VStack (spacing: 10) {
                    Text("Enter your budget")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    TextField("", text: $budget)
                        .keyboardType(.numberPad)
                        .padding()
                        .frame(width: 150)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(.green))
                }
                Button {
                    showMoneyAdd.toggle()
                } label: {
                    Text("Add")
                        .font(.headline)
                        .padding()
                        .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    WalletView(budget: .constant("4.56"), showMoneyAdd: .constant(false))
}

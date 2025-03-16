//
//  BudgetView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct BudgetView: View {
    @Binding var budget: String
    @Binding var showMoneyAdd: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            HStack (spacing: 15) {
                Image(systemName: "wallet.bifold.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(.green.opacity(0.8))
                    .frame(width: 40, height: 40)
                    .background(.white, in: Circle())
                VStack (alignment: .leading, spacing: 5){
                    Text(Double(budget) ?? 0.00, format: .currency(code: "inr"))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Your monthly budget")
                        .font(.caption)
                }
                Spacer()
                Button {
                    withAnimation {
                        showMoneyAdd.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10)
                        .frame(width: 30, height: 30)
                        .background(Color(.systemGray6).opacity(0.25), in: Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .padding(.horizontal)
            .frame(width: 360, height: 50)
            .padding(10)
            .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    BudgetView(budget: .constant("0.76"), showMoneyAdd: .constant(false))
}

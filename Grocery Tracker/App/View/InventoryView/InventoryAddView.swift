//
//  InventoryView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct InventoryAddView: View {
    @State private var item = GroceryModel(id: UUID(), name: "", purchasedDate: Date(), shelfLife: nil, qty: nil)
    @State private var qty = ""
    @State private var itemShelfLife = ""
    @State private var mentionedExpiryDate: Date?
    @StateObject var groceryViewModel = GroceryViewModel()
    @Binding var showInventoryAddView: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack (spacing: 20) {
                Button {
                    withAnimation {
                        showInventoryAddView.toggle()
                    }
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                }
                .frame(width: 280, height: 30, alignment: .trailing)
                .buttonStyle(PlainButtonStyle())
                
                TextField("Item Name", text: $item.name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).stroke())
                
                TextField("Quantity", text: $qty)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).stroke())
                
                DatePicker("Purchased date", selection: $item.purchasedDate, displayedComponents: .date)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).stroke())
                
                TextField("Shelf Life (days)", text: $itemShelfLife)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).stroke())
                
                DatePicker("Expiry date", selection: Binding(
                    get: {
                        mentionedExpiryDate ?? Date()
                    },
                    set: { newValue in
                        if mentionedExpiryDate != newValue {
                            mentionedExpiryDate = newValue
                            item.mentionedExpiredDate = newValue
                            print("User selected expiry date:", newValue)
                        } else {
                            print("User reselected the same date:", newValue)
                        }
                    }
                ), displayedComponents: .date)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).stroke())
                
                Button {
                    if let qtyInt = Int(qty) {
                            item.qty = qtyInt
                        } else {
                            item.qty = 1
                        }
                        
                        if let shelfLifeInt = Int(itemShelfLife) {
                            item.shelfLife = shelfLifeInt
                        }
                        
                        if let userDate = mentionedExpiryDate {
                            item.mentionedExpiredDate = userDate
                        }
                        
                        groceryViewModel.addToInventory(item: item)
                        
                        let currentDate = Calendar.current.startOfDay(for: Date())
                        let twoDaysFromNow = Calendar.current.date(byAdding: .day, value: 2, to: currentDate) ?? currentDate
                        let itemExpiryDate = Calendar.current.startOfDay(for: item.expiringDate)
                        
                        if itemExpiryDate < currentDate {
                            groceryViewModel.addToExpiredList(item: item)
                        } else if itemExpiryDate <= twoDaysFromNow {
                            groceryViewModel.addToExpiringSoonList(item: item)
                        }
                        
                        showInventoryAddView.toggle()
                } label: {
                    Text("Add item to inventory")
                        .fontWeight(.semibold)
                        .padding()
                        .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDisappear(perform: {
                Task {
                    groceryViewModel.loadExpiringSoonList()
                }
            })
            .padding()
            .frame(width: 330, height: 575)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    InventoryAddView(showInventoryAddView: .constant(true))
}

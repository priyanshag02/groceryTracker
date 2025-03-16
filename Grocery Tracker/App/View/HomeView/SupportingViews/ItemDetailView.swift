//
//  ItemDetailView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ItemDetailView: View {
    var item: GroceryModel
    @Binding var isFavourite: Bool
    @Binding var showDetailView: Bool
    @Binding var isPresentInInventory: Bool
    @StateObject var groceryViewModel: GroceryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 40) {
                HStack (spacing: 180) {
                    Button {
                        Task {
                            if groceryViewModel.favourite.contains(where: {$0.id == item.id}) {
                                groceryViewModel.removeFromFavourite(item: item)
                            } else {
                                groceryViewModel.addToFavourite(item: item)
                            }
                            isFavourite = groceryViewModel.favourite.contains(where: {$0.id == item.id})
                            dismiss()
                        }
                    } label : {
                        Image(systemName: groceryViewModel.favourite.contains(where: {$0.id == item.id}) ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                    }
                    
                    Button {
                        Task {
                            if groceryViewModel.inventory.contains(where: {$0.id == item.id}) {
                                groceryViewModel.removeFromInventory(item: item)
                            } else {
                                groceryViewModel.addToInventory(item: item)
                            }
                            isPresentInInventory = groceryViewModel.inventory.contains(where: {$0.id == item.id})
                            dismiss()
                        }
                    } label : {
                        Image(systemName: groceryViewModel.inventory.contains(where: {$0.id == item.id}) ? "shippingbox.fill" : "shippingbox")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(item.name)")
                    .font(.title2)
                    .fontWeight(.bold)
                HStack (spacing: 15) {
                    VStack (alignment: .leading, spacing: 15)  {
                        Text("Purchase date: ")
                            .font(.subheadline)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(height: 15)
                        Text("Shelf Life: ")
                            .font(.subheadline)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(height: 15)
                        Text("Use before: ")
                            .font(.subheadline)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(height: 15)
                        if item.qty != nil {
                            Text("Quantity: ")
                                .font(.subheadline)
                                .foregroundStyle(.green.opacity(0.8))
                                .frame(height: 15)
                        }
                    }
                    VStack (alignment: .leading, spacing: 15) {
                        Text("\(dateFormatter.string(from: item.purchasedDate))")
                            .fontWeight(.bold)
                            .frame(height: 15)
                        if let shelfLife = item.shelfLife {
                            Text("\(shelfLife) days")
                                .fontWeight(.bold)
                                .frame(height: 15)
                        } else {
                            Text("")
                                .fontWeight(.bold)
                                .frame(height: 15)
                        }
                        if let expiry = item.mentionedExpiredDate {
                            Text("\(dateFormatter.string(from: expiry))")
                                .fontWeight(.bold)
                                .frame(height: 15)
                        } else {
                            Text("\(dateFormatter.string(from: item.expiringDate ))")
                                .fontWeight(.bold)
                                .frame(height: 15)
                        }
                        
                        if let qty = item.qty {
                            Text("\(qty)")
                                .fontWeight(.bold)
                                .frame(height: 15)
                        }
                    }
                    
                }
                Button {
                    showDetailView.toggle()
                    Task {
                        do {
                            groceryViewModel.removeFromInventory(item: item)
                            groceryViewModel.removeFromExpiredList(item: item)
                            groceryViewModel.removeFromExpiringSoonList(item: item)
                        }
                    }
                    dismiss()
                } label: {
                    Text("Consumed")
                        .font(.headline)
                        .padding(10)
                        .background(.green.opacity(0.8), in: Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 300, height: 375)
            .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 20))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        showDetailView.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Item Detail View")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ItemDetailView(item: singleItem, isFavourite: .constant(true), showDetailView: .constant(false), isPresentInInventory: .constant(true), groceryViewModel: GroceryViewModel())
}

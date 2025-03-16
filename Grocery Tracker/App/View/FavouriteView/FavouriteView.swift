//
//  FavouriteList.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct FavouriteView: View {
    @Binding var isFavourite: Bool
    @Binding var showDetailView: Bool
    @Binding var isPresentInInventory: Bool
    @ObservedObject var groceryViewModel: GroceryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if groceryViewModel.favourite.isEmpty {
                    Text("Add items to your Favourites.")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack (alignment: .center) {
                        HStack (spacing: 0){
                            Text("Item")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                            Text("Quantity")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                            Text("Best before")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                        }
                        .foregroundStyle(.green.opacity(0.8))
                        .frame(width: 360, height: 30, alignment: .leading)
                        .padding(.top)
                        
                        ScrollView {
                            VStack (spacing: 20) {
                                ForEach(groceryViewModel.favourite) { item in
                                    NavigationLink(destination: ItemDetailView(item: item, isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                                        HStack (spacing: 0) {
                                            Text(item.name)
                                                .font(.headline)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 120, alignment: .center)
                                            
                                            if let qty = item.qty {
                                                Text("\(qty)")
                                                    .font(.footnote)
                                                    .frame(width: 120)
                                            }
                                            
                                            Text(dateFormatter.string(from: item.expiringDate))
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .frame(width: 120)
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                    .frame(height: 60, alignment: .leading)
                                    .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 2)
                                            .foregroundStyle(groceryViewModel.expiredList.contains(where: {$0.id == item.id}) ? .red : (groceryViewModel.expiringSoon.contains(where: {$0.id == item.id}) ? .yellow : .green.opacity(0.8)))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.top)
                        }
                    }
                    .scrollIndicators(.never)
                }
            }
            .onAppear {
                groceryViewModel.loadFavourites()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    FavouriteView(isFavourite: .constant(true), showDetailView: .constant(false), isPresentInInventory: .constant(false), groceryViewModel: GroceryViewModel())
}

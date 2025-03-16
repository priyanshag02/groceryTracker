//
//  NavigationToolBar.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct NavigationToolBar: View {
    @ObservedObject var groceryViewModel: GroceryViewModel
    @Binding var isFavourite: Bool
    @Binding var showDetailView: Bool
    @Binding var isPresentInInventory: Bool
    @Binding var isSubscribed: Bool
    @Binding var subscriberMode: Int
    
    var body: some View {
        NavigationStack {
            
            HStack (spacing: 50){
                Button {
                } label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: FavouriteView(isFavourite: $isFavourite , showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)){
                    Image(systemName: groceryViewModel.favourite.isEmpty ? "heart" : "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                
                NavigationLink (destination: ShoppingListView(groceryViewModel: groceryViewModel)) {
                    Image(systemName: groceryViewModel.shoppingList.isEmpty ?  "list.bullet.rectangle.portrait" : "list.bullet.rectangle.portrait.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .frame(width: 25)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink (destination: InventoryListView(isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                    Image(systemName: groceryViewModel.inventory.isEmpty ?  "shippingbox" : "shippingbox.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink (destination: ProfileView(isSubscribed: $isSubscribed, subscriberMode: $subscriberMode)) {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .frame(width: 25)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .foregroundStyle(.green.opacity(0.8))
            .frame(width: 350, height: 50)
        }
    }
}

#Preview {
    NavigationToolBar(groceryViewModel: GroceryViewModel(), isFavourite: .constant(false), showDetailView: .constant(false), isPresentInInventory: .constant(false), isSubscribed: .constant(false), subscriberMode: .constant(0))
}

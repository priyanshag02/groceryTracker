//
//  ContentView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var groceryViewModel = GroceryViewModel()
    @State private var isFavourite: Bool = false
    @State private var showDetailView: Bool = false
    @State private var isPresentInInventory: Bool = false
    @State private var isSubscribed: Bool = false
    @State private var subscriberMode: Int = 0
    
    var body: some View {
        if authViewModel.isLoading {
            ProgressView("Loading")
        } else {
            if authViewModel.currentUser == nil {
                WelcomeView()
            } else {
                TabView {
                    HomeView(groceryViewModel: groceryViewModel)
                        .tabItem {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text("Home")
                        }
                    
                    FavouriteView(isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)
                        .tabItem {
                            Image(systemName: groceryViewModel.favourite.isEmpty ? "heart" : "heart.fill")
                            Text("Favourites")
                        }
                    
                    ShoppingListView(groceryViewModel: groceryViewModel)
                        .tabItem {
                            Image(systemName: groceryViewModel.shoppingList.isEmpty ? "list.bullet.rectangle.portrait" : "list.bullet.rectangle.portrait.fill")
                            Text("Shopping List")
                        }
                    
                    InventoryListView(isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)
                        .tabItem {
                            Image(systemName: groceryViewModel.inventory.isEmpty ? "shippingbox" : "shippingbox.fill")
                            Text("Inventory")
                        }
                    
                    ProfileView(isSubscribed: $isSubscribed, subscriberMode: $subscriberMode)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .accentColor(.green)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}

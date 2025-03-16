//
//  HomeView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var groceryViewModel: GroceryViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isExpanded: Bool = false
    @State var adults: Int = 3
    @State var children: Int = 1
    @State var addingMembers: Bool = false
    @State var isSubscribed: Bool = false
    @State var subscriberMode: Int = 0
    @State var isFavourite: Bool = false
    @State var showDetailView: Bool = false
    @State var isPresentInInventory: Bool = false
    @State var budget: String = ""
    @State var showMoneyAdd: Bool = false
    @State var showInventoryAddView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack (alignment: .leading, spacing: 30) {
                            ScrollOfferView()
                            BudgetView(budget: $budget, showMoneyAdd: $showMoneyAdd)
                                .buttonStyle(PlainButtonStyle())
                            ExpiredProductView(isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)
                            ExpiringSoonView(groceryViewModel: groceryViewModel, isWishlisted: $isFavourite, showDetailView: $showDetailView, isExpiringExpanded: $isExpanded, isPresentInInventory: $isPresentInInventory)
                                .id("ExpiringSoonView")
                                .onChange(of: isExpanded) { oldValue, newValue in
                                    if newValue {
                                        withAnimation {
                                            proxy.scrollTo("ExpiringSoonView", anchor: .top)
                                        }
                                    }
                                }
                            MembersView(adults: $adults, children: $children, addingMembers: $addingMembers)
                            Rectangle()
                                .fill(Color(.systemGray6).opacity(0.1))
                                .frame(height: 80)
                        }
                        .padding()
                    }
                    .opacity(addingMembers || showMoneyAdd || showInventoryAddView ? 0.1 : 1)
                    .scrollIndicators(.never)
                    .padding()
                    .overlay {
                        if addingMembers {
                            FamilyView(adults: $adults, children: $children, addingMembers: $addingMembers)
                                .padding()
                        }
                    }
                    .overlay {
                        if showMoneyAdd {
                            WalletView(budget: $budget, showMoneyAdd: $showMoneyAdd)
                                .padding()
                        }
                    }
                    .overlay {
                        if showInventoryAddView {
                            InventoryAddView(showInventoryAddView: $showInventoryAddView)
                                .padding()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack (spacing: 10) {
                                Button {
                                    withAnimation (.smooth) {
                                        showInventoryAddView.toggle()
                                    }
                                } label: {
                                    Image(systemName: "camera.metering.none")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                }
                                .frame(width: 35, height: 35)
                                .background(.green.opacity(0.8), in: Circle())
                                .buttonStyle(PlainButtonStyle())
                                
                                Text("Grocery tracker")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .padding(.bottom, 10)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            if isSubscribed {
                                Image(systemName: "crown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 25)
                                    .frame(width: 35, height: 35)
                                    .background(.green.opacity(0.8), in: Circle())
                                    .padding(.bottom, 10)
                            } else {
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
                                    .frame(width: 130, height: 35)
                                    .background(.green.opacity(0.8), in: Capsule())
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .ignoresSafeArea(.all)
        
    }
}

#Preview {
    HomeView(groceryViewModel: GroceryViewModel())
        .environmentObject(AuthViewModel())
}

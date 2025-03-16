//
//  ProductCatalogue.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ExpiredProductView: View {
    @Binding var isFavourite: Bool
    @Binding var showDetailView: Bool
    @Binding var isPresentInInventory: Bool
    @StateObject var groceryViewModel: GroceryViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            Text("Expired Product")
                .fontWeight(.bold)
                .padding(.leading, 25)
            
            VStack (spacing: 10) {
                HStack (spacing: 15) {
                    Text("Total Products")
                        .fontWeight(.semibold)
                        .padding(.leading)
                    Text("\(groceryViewModel.expiredList.count)")
                        .frame(width: 30, height: 30)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.white)
                        }
                    
                    Spacer()
                    
                    HStack (spacing: 5) {
                        NavigationLink (destination: ExpiredListView(isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                            Text("View all")
                                .fontWeight(.bold)
                                .foregroundStyle(.green.opacity(0.8))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                ScrollView (.horizontal) {
                    LazyHStack (spacing: 25){
                        ForEach (0..<groceryViewModel.expiredList.count, id: \.self) { index in
                            NavigationLink (destination: ItemDetailView(item: groceryViewModel.expiredList[index], isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                                VStack (spacing: 5) {
                                    Text("\(groceryViewModel.expiredList[index].name)")
                                        .foregroundStyle(.red.opacity(0.8))
                                        .fontWeight(.semibold)
                                    HStack (spacing: 0) {
                                        Text("Expired on: ")
                                            .font(.caption)
                                        Text(dateFormatter.string(from: groceryViewModel.expiredList[index].expiringDate))
                                            .font(.caption)
                                    }
                                    Text("Qty: \(groceryViewModel.expiredList[index].qty ?? 0)")
                                        .font(.caption)
                                }
                                .frame(width: 150, height: 80)
                                .background(.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.leading, 10)
                }
                .scrollIndicators(.never)
            }
            .padding(10)
            .frame(width: 360, height: groceryViewModel.expiredList.isEmpty ? 60 :  175)
            .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 20))
        }
        .onAppear {
            Task {
                groceryViewModel.loadExpiredList()
            }
        }
    }
}

#Preview {
    ExpiredProductView(isFavourite: .constant(false), showDetailView: .constant(false), isPresentInInventory: .constant(false), groceryViewModel: GroceryViewModel())
}

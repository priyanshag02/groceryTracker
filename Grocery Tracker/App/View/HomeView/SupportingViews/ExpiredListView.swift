//
//  ExpiredListView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ExpiredListView: View {
    @Binding var isFavourite: Bool
    @Binding var showDetailView: Bool
    @Binding var isPresentInInventory: Bool
    @ObservedObject var groceryViewModel: GroceryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if groceryViewModel.expiredList.isEmpty {
                    Group {
                        Text("Hurray!")
                            .font(.title2)
                        Text("No expired Food")
                            .font(.title3)
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.green.opacity(0.8))
                    .padding()
                } else {
                    VStack {
                        HStack (spacing: 10){
                            Text("Item")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                            Text("Quantity")
                                .fontWeight(.semibold)
                                .frame(width: 100)
                            Text("Expired on")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                        }
                        .foregroundStyle(.green.opacity(0.8))
                        .frame(width: 360, height: 30, alignment: .leading)
                        
                        ScrollView {
                            VStack (spacing: 20) {
                                ForEach(groceryViewModel.expiredList) { item in
                                    NavigationLink(destination: ItemDetailView(item: item, isFavourite: $isFavourite, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                                        
                                        HStack (spacing: 10) {
                                            Text(item.name)
                                                .font(.headline)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 120, alignment: .center)
                                            
                                            if let qty = item.qty {
                                                Text("\(qty)")
                                                    .font(.footnote)
                                                    .frame(width: 100)
                                            }
                                            
                                            Text(dateFormatter.string(from: item.expiringDate))
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .frame(width: 120)
                                        }
                                    }
                                    .frame(width: 360 ,height: 60, alignment: .leading)
                                    .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 20))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .scrollIndicators(.never)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack (spacing: 15) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text("Expired Items List")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .onAppear {
                Task {
                    groceryViewModel.loadExpiredList()
                }
            }
        }
        .navigationBarBackButtonHidden()    }
}

#Preview {
    ExpiredListView(isFavourite: .constant(false), showDetailView: .constant(false), isPresentInInventory: .constant(false), groceryViewModel: GroceryViewModel())
}

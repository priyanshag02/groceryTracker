//
//  ExpiringView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ExpiringSoonView: View {
    @StateObject var groceryViewModel: GroceryViewModel
    @Binding var isWishlisted: Bool
    @Binding var showDetailView: Bool
    @Binding var isExpiringExpanded: Bool
    @Binding var isPresentInInventory: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            Text("Expiring Soon")
                .fontWeight(.bold)
                .padding(.leading, 25)
            
            VStack {
                HStack(spacing: 15) {
                    Text("Total Products")
                        .fontWeight(.semibold)
                    Text("\(groceryViewModel.expiringSoon.count)")
                        .frame(width: 30, height: 30)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.white)
                        }
                    Spacer()
                    Button {
                        withAnimation {
                            isExpiringExpanded.toggle()
                        }
                    } label: {
                        Text("View all")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 10)
                
                if isExpiringExpanded {
                    ScrollView (.horizontal) {
                        LazyHStack (spacing: 10) {
                            if groceryViewModel.expiringSoon.isEmpty {
                                Text("No items expiring soon.")
                                    .padding()
                            } else {
                                ForEach(0..<groceryViewModel.expiringSoon.count, id: \.self) { index in
                                        VStack(alignment: .center, spacing: 5) {
                                            Group {
                                                Text(groceryViewModel.expiringSoon[index].name)
                                                    .fontWeight(.bold)
                                                
                                                Text("Expiry Date: \(dateFormatter.string(from: groceryViewModel.expiringSoon[index].expiringDate))")
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                            .padding(.horizontal, 5)
                                            
                                            NavigationLink (destination: ItemDetailView(item: groceryViewModel.expiringSoon[index], isFavourite: $isWishlisted, showDetailView: $showDetailView, isPresentInInventory: $isPresentInInventory, groceryViewModel: groceryViewModel)) {
                                                Text("View Details")
                                                    .font(.footnote)
                                                    .fontWeight(.bold)
                                                    .padding(10)
                                                    .overlay {
                                                        Capsule()
                                                            .stroke(lineWidth: 1)
                                                    }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    .frame(width: 175, height: 110)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 2)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 10)
                    }
                    .scrollIndicators(.never)
                }
            }
            .frame(width: 360, height: isExpiringExpanded ? 160 : 40)
            .padding(10)
            .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
        }
        .onAppear {
            Task {
                groceryViewModel.loadExpiringSoonList()
            }
        }
    }
}

#Preview {
    NavigationView {
        ExpiringSoonView(groceryViewModel: GroceryViewModel(), isWishlisted: .constant(true), showDetailView: .constant(true), isExpiringExpanded: .constant(true), isPresentInInventory: .constant(false))
    }
}

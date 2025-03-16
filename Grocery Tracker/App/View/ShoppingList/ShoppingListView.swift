//
//  ShoppingListView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 15/03/25.
//

import SwiftUI

struct ShoppingListView: View {
    @ObservedObject var groceryViewModel: GroceryViewModel
    @Environment(\.dismiss) var dismiss
    @State var addItem: Bool = false
    @State var itemName: String = ""
    
    var body: some View {
        NavigationStack {
            VStack () {
                if groceryViewModel.shoppingList.isEmpty {
                    Text("Add items to your Shopping List.")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(Array(groceryViewModel.shoppingList.enumerated()), id: \.element) { index, item in
                            HStack (spacing: 10) {
                                Text("\(index + 1).")
                                    .frame(width: 25)
                                Text("\(item)")
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button (role: .destructive) {
                                    groceryViewModel.removeFromShoppingList(item: groceryViewModel.shoppingList[index])
                                } label: {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                }
                            }
                            .frame(width: 300, alignment: .leading)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.never)
                    .padding(.trailing, 30)
                    .padding(.top, 15)
                }
                
                    Button {
                        withAnimation {
                            addItem = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundStyle(.green.opacity(0.8))
                    }
                    .padding(.bottom, 30)
            }
            .sheet(isPresented: $addItem, content: {
                AddItemSheet(groceryViewModel: groceryViewModel, addItem: $addItem, itemName: $itemName)
            })
            .onAppear {
                groceryViewModel.loadShoppingList()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ShoppingListView(groceryViewModel: GroceryViewModel())
}

struct AddItemSheet: View {
    @ObservedObject var groceryViewModel: GroceryViewModel
    @Binding var addItem: Bool
    @Binding var itemName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack (spacing: 20) {
            Spacer()
            HStack {
                Button {
                    addItem = false
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
                
                Button {
                    if !itemName.isEmpty {
                        groceryViewModel.addToShoppingList(item: itemName)
                    }
                    addItem = false
                    itemName = ""
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: 320, alignment: .trailing)
            
            TextField("Add item", text: $itemName)
                .padding(.horizontal, 10)
                .frame(width: 330, height: 50)
                .background(Color(.systemGray3), in: RoundedRectangle(cornerRadius: 20))
            Spacer()
        }
        .background(Color(.systemGray6))
        .presentationDetents([.height(150)])
    }
}

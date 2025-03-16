//
//  GroceryViewModel.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import Foundation
import SwiftUI

class GroceryViewModel: ObservableObject {
    @Published var inventory: [GroceryModel] = []
    @Published var expiredList: [GroceryModel] = []
    @Published var expiringSoon: [GroceryModel] = []
    @Published var favourite: [GroceryModel] = []
    @Published var shoppingList: [String] = []
    
    private let inventoryKey = "inventoryKey"
    private let expiredListKey = "expiredListKey"
    private let expiringSoonKey = "expiringSoonKey"
    private let favouriteKey = "favouriteKey"
    private let shoppingListKey = "shoppingListKey"
    
    
    init() {
        loadInventory()
        loadFavourites()
        loadExpiredList()
        loadExpiringSoonList()
        loadShoppingList()
    }
    
    //MARK: Inventory List Management
    
    func addToInventory(item: GroceryModel) {
        Task {
            await MainActor.run {
                inventory.append(item)
                saveInventory()
            }
        }
    }
    
    func removeFromInventory(item: GroceryModel) {
        Task {
            await MainActor.run {
                inventory.removeAll { $0.id == item.id }
                saveInventory()
            }
        }
    }
    
    private func saveInventory() {
        Task {
            if let encoded = try? JSONEncoder().encode(inventory) {
                await MainActor.run {
                    UserDefaults.standard.set(encoded, forKey: inventoryKey)
                }
            }
        }
    }
    
    func loadInventory() {
        Task {
            if let savedData = UserDefaults.standard.data(forKey: inventoryKey),
               let decodedInventory = try? JSONDecoder().decode([GroceryModel].self, from: savedData) {
                await MainActor.run {
                    inventory = decodedInventory
                }
            }
        }
    }
    
    //MARK: Favourite List Management
    
    func addToFavourite(item: GroceryModel) {
        Task {
            if !favourite.contains(where: { $0.id == item.id }) {
                await MainActor.run {
                    favourite.append(item)
                    saveFavourite()
                }
            }
        }
    }
    
    func removeFromFavourite(item: GroceryModel) {
        Task {
            await MainActor.run {
                favourite.removeAll { $0.id == item.id }
                saveFavourite()
            }
        }
    }
    
    private func saveFavourite() {
        Task {
            if let encoded = try? JSONEncoder().encode(favourite) {
                await MainActor.run {
                    UserDefaults.standard.set(encoded, forKey: favouriteKey)
                }
            }
        }
    }
    
    func loadFavourites() {
        Task {
            if let savedData = UserDefaults.standard.data(forKey: favouriteKey),
               let decodedWishlist = try? JSONDecoder().decode([GroceryModel].self, from: savedData) {
                await MainActor.run {
                    favourite = decodedWishlist
                }
            }
        }
    }
    
    //MARK: Expired List Management
    
    func addToExpiredList(item: GroceryModel) {
        Task {
            let currentDate = Calendar.current.startOfDay(for: Date())
            let expiryDate = Calendar.current.startOfDay(for: item.expiringDate)
            
            await MainActor.run {
                if expiryDate < currentDate {
                    expiredList.append(item)
                    saveExpiredList()
                }
            }
        }
    }
    
    private func saveExpiredList() {
        Task {
            if let encoded = try? JSONEncoder().encode(expiredList) {
                await MainActor.run {
                    UserDefaults.standard.set(encoded, forKey: expiredListKey)
                }
            }
        }
    }
    
    func loadExpiredList() {
        Task {
            if let savedData = UserDefaults.standard.data(forKey: expiredListKey),
               let decodedExpiredList = try? JSONDecoder().decode([GroceryModel].self, from: savedData) {
                await MainActor.run {
                    expiredList = decodedExpiredList
                }
            }
        }
    }
    
    func removeFromExpiredList(item: GroceryModel) {
        Task {
            await MainActor.run {
                expiredList.removeAll(where: {$0.id == item.id})
                saveExpiredList()
            }
        }
    }
    
    //MARK: ExpiringSoon List Management
    
    func addToExpiringSoonList(item: GroceryModel) {
        Task {
            let currentDate = Calendar.current.startOfDay(for: Date())
            let twoDaysFromNow = Calendar.current.date(byAdding: .day, value: 2, to: currentDate) ?? currentDate
            let expiryDate = Calendar.current.startOfDay(for: item.expiringDate)
            
            await MainActor.run {
                if expiryDate >= currentDate && expiryDate <= twoDaysFromNow {
                    expiringSoon.append(item)
                    saveExpiringSoonList()
                }
            }
        }
    }
    
    private func saveExpiringSoonList() {
        Task {
            if let encoded = try? JSONEncoder().encode(expiringSoon) {
                await MainActor.run {
                    UserDefaults.standard.set(encoded, forKey: expiringSoonKey)
                }
            }
        }
    }
    
    func loadExpiringSoonList() {
        Task {
            if let savedData = UserDefaults.standard.data(forKey: expiringSoonKey),
               let decodedExpiringSoon = try? JSONDecoder().decode([GroceryModel].self, from: savedData) {
                await MainActor.run {
                    expiringSoon = decodedExpiringSoon
                }
            }
        }
    }
    
    func removeFromExpiringSoonList(item: GroceryModel) {
        Task {
            await MainActor.run {
                expiringSoon.removeAll(where: {$0.id == item.id})
                saveExpiringSoonList()
            }
        }
    }
    
    //MARK: Shopping List Management
    
    func addToShoppingList(item: String) {
        Task {
            await MainActor.run {
                if !self.shoppingList.contains(where: { $0 == item }) {
                    self.shoppingList.append(item)
                }
                self.saveShoppingList()
            }
        }
    }
    
    func removeFromShoppingList(item: String) {
        Task {
            await MainActor.run {
                self.shoppingList.removeAll(where: { $0 == item })
                self.saveShoppingList()
            }
        }
    }
    
    private func saveShoppingList() {
        Task {
            if let encodedData = try? JSONEncoder().encode(shoppingList) {
                await MainActor.run {
                    UserDefaults.standard.set(encodedData, forKey: shoppingListKey)
                }
            }
        }
    }
    
    func loadShoppingList() {
        Task {
            if let savedData = UserDefaults.standard.data(forKey: shoppingListKey),
               let decodedShoppingList = try? JSONDecoder().decode([String].self, from: savedData) {
                await MainActor.run {
                    self.shoppingList = decodedShoppingList
                }
            }
        }
    }
}

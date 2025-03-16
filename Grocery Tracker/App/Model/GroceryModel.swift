//
//  GroceryModel.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import Foundation

struct GroceryModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var purchasedDate: Date
    var shelfLife: Int?
    var qty: Int?
    var mentionedExpiredDate: Date?
    var expiringDate: Date {
        get {
            if let userDate = mentionedExpiredDate {
                return Calendar.current.startOfDay(for: userDate) 
            } else if let shelfLifeDays = shelfLife {
                return Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: shelfLifeDays, to: purchasedDate) ?? purchasedDate)
            }
            return Calendar.current.startOfDay(for: purchasedDate) // Default to purchase date if nothing is mentioned
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yy"
    return formatter
}()

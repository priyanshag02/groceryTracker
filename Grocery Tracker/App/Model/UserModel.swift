//
//  UserModel.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var fullName: String
    var email: String
    var phone: String
}

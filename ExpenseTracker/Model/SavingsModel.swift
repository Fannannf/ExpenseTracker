//
//  SavingsModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 21/09/24.
//

import Foundation
import SwiftData

@Model
class SavingsModel: Identifiable, ObservableObject {
    @Attribute(.unique) var id: UUID
    let date: Date
    var amount: Int
    
    init(date: Date, amount: Int) {
        self.id = UUID()
        self.date = date
        self.amount = amount
    }
}

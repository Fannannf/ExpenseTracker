//
//  TransactionModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import Foundation
import SwiftData

@Model
class TransactionModel: Identifiable {
    @Attribute(.unique) var id: UUID
    let title: String
    let categori: String
    let date: Date
    let amount: Int
    let status: String
    let monthly: Bool
    
    init(title: String, categori: String, date: Date, amount: Int, status: String, monthly: Bool) {
        self.id = UUID()
        self.title = title
        self.categori = categori
        self.date = date
        self.amount = amount
        self.status = status
        self.monthly = monthly
    }
}

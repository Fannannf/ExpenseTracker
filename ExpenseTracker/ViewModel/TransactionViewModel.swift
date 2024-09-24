//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 21/09/24.
//

import Foundation

import SwiftData
import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var titleAlertMessage = ""
    @Published var incomeTransactions: [TransactionModel] = []
    @Published var totalExpense: Int = 0
    
    func fetchIncomeTransactions(modelContext: ModelContext) {
        let request = FetchDescriptor<TransactionModel>(
            predicate: #Predicate { $0.status == "income" }
        )
        do {
            incomeTransactions = try modelContext.fetch(request)
        } catch {
            print("Failed to fetch income transactions: \(error)")
        }
    }
    
    func calculateTotalExpense(transactions: [TransactionModel]) -> Int {
        let totalExpense = transactions
            .filter { $0.status == "expense" }
            .map { $0.amount }
            .reduce(0, +)
        
        return totalExpense
    }

    func addTransaction(title: String, category: String, transactionDate: Date, amount: Int64, status: String, modelContext: ModelContext, balance: [BalanceModel], savings: [SavingsModel]) {
        fetchIncomeTransactions(modelContext: modelContext)
        var currentBalance = balance.first?.amount ?? 0
        var currentSavings = balance.first?.savings ?? 0
        var currentGoals = balance.first?.goals ?? 0
        
        if amount == 0 && status == "income" {
            titleAlertMessage = "Missing Amount"
            alertMessage = "Amount cannot be empty for an income transaction."
            showAlert = true
        } else if status == "expense" {
            if incomeTransactions.isEmpty {
                titleAlertMessage = "No Income Found"
                alertMessage = "Please enter income before adding an expense."
                showAlert = true
            } else if currentBalance < amount {
                titleAlertMessage = "Insufficient Balance"
                alertMessage = "Your balance is not enough to cover this expense."
                showAlert = true
            } else {
                currentBalance -= Int64(amount)
                balance.first?.amount = currentBalance
                balance.first?.date_logged = transactionDate
                modelContext.insert(TransactionModel(title: title, categori: category, date: transactionDate, amount: Int(amount), status: status))
                try? modelContext.save()
            }
        } else if status == "income" {
            let balanceAmount = Int(Double(amount) * 0.50)
            let savingsAmount = Int(Double(amount) * 0.20)
            let goalsAmount = Int(Double(amount) * 0.30)
            
            if balance.isEmpty {
                let initialBalance = BalanceModel(amount: Int64(balanceAmount), savings: Int64(savingsAmount), goals: Int64(goalsAmount))
                modelContext.insert(initialBalance)
                try? modelContext.save()
                currentBalance = initialBalance.amount
                currentSavings = initialBalance.savings
                currentGoals = initialBalance.goals
                print("Initial balance created")
            }else {
                currentBalance += Int64(balanceAmount)
                currentSavings += Int64(savingsAmount)
                currentGoals += Int64(goalsAmount)
                balance.first?.amount = currentBalance
                balance.first?.savings = currentSavings
                balance.first?.goals = currentGoals
                balance.first?.date_logged = transactionDate
            }
            
            
            
            if savings.isEmpty {
                let savings = Int(Double(amount) * 0.20)
                let initialSavings = SavingsModel(date: Date(), amount: savings)
                modelContext.insert(initialSavings)
                try? modelContext.save()
                currentSavings = Int64(initialSavings.amount)
            }else{
                modelContext.insert(SavingsModel(date: transactionDate, amount: savingsAmount))
            }
            
            modelContext.insert(TransactionModel(title: title, categori: category, date: transactionDate, amount: Int(amount), status: status))
            try? modelContext.save()
        } else {
            titleAlertMessage = "Unknown Error"
            alertMessage = "An unexpected error occurred. Please try again."
            showAlert = true
        }
    }
}

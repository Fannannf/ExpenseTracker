//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI
import TipKit

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TransactionModel.self,BalanceModel.self,SavingsModel.self])
    }
    
    init() {
        try? Tips.configure()
    }
}

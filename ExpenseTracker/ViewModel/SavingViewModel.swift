//
//  SavingViewModel.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 22/09/24.
//

import Foundation
import SwiftData

class SavingViewModel: ObservableObject {
    @Published var monthlySavings: [String: Int] = [:]

    func calculateMonthlySavings(savings: [SavingsModel]) {
        var totals: [String: Int] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        for saving in savings {
            let monthKey = dateFormatter.string(from: saving.date)
            if let currentTotal = totals[monthKey] {
                totals[monthKey] = currentTotal + saving.amount
            } else {
                totals[monthKey] = saving.amount
            }
        }
        DispatchQueue.main.async {
            self.monthlySavings = totals
        }
    }
}

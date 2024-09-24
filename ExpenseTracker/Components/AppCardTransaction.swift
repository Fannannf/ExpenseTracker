//
//  AppCardTransaction.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI


struct CardTransaction: View {
    var transaction: TransactionModel
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(dateFormatter.string(from: transaction.date))
                    .font(.subheadline)
                Text(transaction.categori)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .foregroundColor(Color("textBlackColor"))
            Spacer()
            Text("Rp \(numberFormatter.string(from: NSNumber(value: transaction.amount)) ?? "0")")
                .foregroundColor(transaction.status == "expense" ? .red : .green)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(Color("cardHistoryColor"))
        .cornerRadius(12)
    }
}

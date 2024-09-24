//
//  AddTransaction.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = TransactionViewModel()
    @Query var balance: [BalanceModel]
    @Query var savings: [SavingsModel]
    
    @Binding var isPresented: Bool
    @Binding var transactionType: String
    @State private var title: String = ""
    @State private var amount: Int64 = 0
    @State private var category: String = ""
    @State private var transactionDate = Date()
    @State private var isMonthly = false
    @State private var showAlert = false
    
    @State private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private func categoryOptions() -> [String] {
        switch transactionType {
        case "Expenses":
            return ["Living", "Food & Beverage", "Education", "Fashion", "Other"]
        case "Income":
            return ["Salary", "Pocket Money"]
        default:
            return []
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $transactionType) {
                    Text("Expenses").tag("Expenses")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())

                HStack {
                    Text("Amount")
                        .foregroundColor(.black)
                        .padding(.trailing,21)
                    TextField(value: $amount, formatter: numberFormatter){
                        Text("200.000")
                    }
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Title")
                        .foregroundColor(.black)
                        .padding(.trailing,10)
                    TextField("Title", text: $title)
                        .multilineTextAlignment(.trailing)
                }

                Picker("Category", selection: $category) {
                    ForEach(categoryOptions(), id: \.self) { option in
                        Text(option).tag(option)
                    }
                }

                DatePicker("Date", selection: $transactionDate, displayedComponents: .date)

                Toggle(isOn: $isMonthly) {
                    Text("Monthly")
                }
            }
            .navigationBarTitle("New Transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                }.foregroundColor(.red),
                trailing: Button{
                    if transactionType == "Expenses" {
                        if category == "" {
                            category = "Living"
                        }
                        viewModel.addTransaction(title: title, category: category, transactionDate: transactionDate, amount: amount, status: "expense",monthly: isMonthly, modelContext: modelContext,balance: balance, savings: savings)
                        self.isPresented = false
                    } else if transactionType == "Income" {
                        if category == "" {
                            category = "Salary"
                        }
                        viewModel.addTransaction(title: title, category: category, transactionDate: transactionDate, amount: amount, status: "income",monthly: isMonthly, modelContext: modelContext,balance: balance, savings: savings)
                        self.isPresented = false
                    }
                }label: {
                    Text("Add")
                }.foregroundColor(.blue)
            ).alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.titleAlertMessage),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    AddTransactionView(isPresented: .constant(true), transactionType: .constant("expense"))
}
